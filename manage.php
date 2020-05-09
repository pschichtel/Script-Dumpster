<?php
    error_reporting(-1);

    defined('__DIR__') or define('__DIR__', dirname(__FILE__));
    define('DS', DIRECTORY_SEPARATOR);
    define('NAME_DELIM', '.');
    define('SERVERDIR', __DIR__ . DS . 'servers');
    define('PACKAGEDIR', __DIR__ . DS . 'packages');
    define('__WINDOWS', (PHP_OS == 'WINNT' ? true : false));
    
    /**
     * 
     */
    class ServerManagerException extends Exception
    {
        /**
         *
         * @param string $message the exception message
         * @param int $code the exception code
         */
        public function __construct($message, $code = 0)
        {
            parent::__construct($message, $code);
            Logger::write('Exception', '{BLACK}{_RED}' . $message, true);
        }
    }
    
    class Proc
    {
        protected $process;
        protected $numeric;
        
        /**
         *
         * @param string $process the process id/name
         * @param bool $numeric if a processID was given
         */
        private function __construct($process, $numeric = false)
        {
            $this->process = $process;
            $this->numeric = $numeric;
        }
        
        /**
         *
         * @param string $process the process
         * @return Proc the process object
         */
        public static function factory($process)
        {
            if (Util::is_numeric($process))
            {
                return new self(intval($process), true);
            }
            elseif (Util::matches('/^[\w\d\.]+$/i', trim($process)))
            {
                return new self(trim($process));
            }
            else
            {
                return null;
            }
        }
        
        /**
         *
         * @return bool true is the process is running, otherwise false
         */
        public function isRunning()
        {
            if (__WINDOWS)
            {
                if ($this->numeric)
                {
                    $tasklist = self::exec("tasklist /FI \"PID eq $pid\"");
                    if (Util::matches($pid, implode("\n", $tasklist[0]), false))
                    {
                        return true;
                    }
                }
                else
                {
                    $tasklist = Util::exec('tasklist /FI "IMAGENAME eq ' . $this->process . '"');
                    if (Util::matches($this->process, implode("\n", $tasklist[0]), false))
                    {
                        return true;
                    } 
                }
            }
            else
            {
                $kill = self::exec("kill -0 $pprocess");
                if ($kill[1] === 0)
                {
                    return true;
                }
            }
        }
        
        /**
         *
         * @param bool $force whether to force kill the process
         * @return bool true on success, otherwise false
         */
        public function kill($force)
        {
            if (__WINDOWS)
            {
                $cmd = 'taskkill ';
                $cmd .= ($this->numeric ? '/pid' : '/im');
                $cmd .= ' ' . $this->process;
                if ($force)
                {
                    $cmd .= ' /f';
                }
            }
            else
            {
                $cmd = 'kill ';
                $cmd .= ($force ? '-KILL' : '-SIGTERM');
                $cmd .= ' ' . $this->process;
            }
            $kill = Util::exec($cmd);
            if ($kill[1] === 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    /**
     * 
     */
    class Util
    {
        /**
         *
         * @param string $string the string to check
         * @return bool true if the string consists of numbers, otherwise false
         */
        public static function is_numeric($string)
        {
            return (bool) preg_match('/^\d+$/', $string);
        }

        /**
         *
         * @param string $string the string to check
         * @return bool true if the string is not empty, otherwise false
         */
        public static function notEmpty($string)
        {
            return !empty($string);
        }

        /**
         *
         * @param string $pattern the pattern to search in the string
         * @param string $string the string to search in
         * @param bool $regex whether to pattern is a regular expression or not
         * @return bool true if the pattern matched to string, otherwise false
         */
        public static function matches($pattern, $string, $regex = true)
        {
            if (!$regex)
            {
                $pattern = '/' . preg_quote($pattern, '/') . '/';
            }
            return ((bool) preg_match($pattern, $string));
        }

        /**
         *
         * @param string $name the name to validate
         * @return bool true on success, false on failure
         */
        public static function validName($name)
        {
            return self::matches('/^[a-z]+' . preg_quote(NAME_DELIM, '/') . '[a-z]+$/', $name);
        }

        /**
         *
         * @param type $name the name to parse
         */
        public static function parseName($name)
        {
            if (!self::validName($name))
            {
                throw new ServerManagerException('Util::parseName(1): Invalid name given! Syntax: game\name', 401);
            }
            
            return explode(NAME_DELIM, $name);
        }

        /**
         *
         * @param string $command the command to execute
         * @return mixed[] 
         */
        public static function exec($command)
        {
            $output;
            $return_var;
            exec($command, $output, $return_var);

            return array($output, $return_var);
        }
        
        /**
         *
         * @param string $string the string to print
         */
        public static function println($string)
        {
            Logger::write('Info', $string, true);
        }
        
        /**
         *
         * @staticvar array $ANSI
         * @param string $string the string to parse
         * @param bool $autoclear whether to add {CLEAR} to the end
         * @param bool $strip whether to strip the code out instead of replacing
         * @return string the parsed string
         */
        public static function parseAnsi($string, $autoclear = true, $strip = false)
        {
            static $ANSI = array(
                '{CLEAR}'        => "\033[0m",
                '{BOLD}'         => "\033[1m",
                '{UNDERLINE}'    => "\033[4m",
                '{BLINK}'        => "\033[5m",
                '{INVERSE}'      => "\033[7m",
                
                '{BLACK}'        => "\033[30m",
                '{RED}'          => "\033[31m",
                '{GREEN}'        => "\033[m32",
                '{YELLOW}'       => "\033[m33",
                '{BLUE}'         => "\033[m34",
                '{MAGENTA}'      => "\033[m35",
                '{CYAN}'         => "\033[m36",
                '{WHITE}'        => "\033[m37",
                
                '{_BLACK}'       => "\033[m40",
                '{_RED}'         => "\033[m41",
                '{_GREEN}'       => "\033[m42",
                '{_YELLOW}'      => "\033[m43",
                '{_BLUE}'        => "\033[m44",
                '{_MAGENTA}'     => "\033[m45",
                '{_CYAN}'        => "\033[m46",
                '{_WHITE}'       => "\033[m47"
            );
            
            if (__WINDOWS || $strip)
            {
                $string = str_replace(array_keys($ANSI), '', $string);
            }
            else
            {
                $string = str_replace(array_keys($ANSI), array_values($ANSI), $string);
                if ($autoclear)
                {
                    $string .= $ANSI['{CLEAR}'];
                }
            }
            
            return $string;
        }
    }
    
    /**
     * 
     */
    class Logger
    {
        protected static $file = null;
        
        /**
         *
         * @param string $type the message type
         * @param string $text the text
         * @param bool $screenonly whether to print only on the screen
         */
        public static function write($type, $text, $screenonly = true)// = false)
        {
            $timestamp = date('d.m. H:i:s');
            $pre = "[$timestamp][$type] ";
            echo $pre . Util::parseAnsi($text) . "\n";
            if ($screenonly)
            {
                return;
            }
            try
            {
                self::open();
                fwrite(self::$file, $pre . Util::parseAnsi($text, false, true) . "\n");
            }
            catch(ServerManagerException $sme)
            {}
        }
        
        /**
         * 
         */
        protected static function open()
        {
            if (self::$file === null)
            {
                if (!is_writable(__DIR__))
                {
                    chmod(__DIR__, 0766);
                    if (!is_writable(__DIR__))
                    {
                        throw new ServerManagerException('Logger::open(): Script path is not writable!');
                    }
                }
                self::$file = fopen(__DIR__ . '/servermanager.log', 'ab');
                if (self::$file === false)
                {
                    self::$file = null;
                    throw new ServerManagerException('Logger::open(): Log could not be opened!');
                }
                self::write('Logger', 'Log opened');
            }
        }
    }

    class MySQLConfig
    {
        const HOST      = 'localhost';
        const USER      = 'root';
        const PASS      = '';
        const DBNAME    = 'servermanager';
        const CHARSET   = 'UTF8';
    }
    
    class SQLiteConfig
    {
        const FILE      = 'servers.db';
    }
    
    abstract class Database
    {
    
        protected $db;
        //protected $path;
        protected $error;
        private $connected = false;
        
        /**
         * 
         */
        public function init(/*$path*/)
        {
            //$this->path = $path;
            $this->db = null;
        }
        
        /**
         * 
         */
        protected function connect()
        {
            if (!$this->connected)
            {
                $this->db = mysql_connect(MySQLConfig::HOST, MySQLConfig::USER, MySQLConfig::PASS);
                if (!is_resource($this->db))
                {
                    throw new ServerManagerException('Connection to the database failed!', 501);
                }
                if (!mysql_select_db(MySQLConfig::DBNAME, $this->db))
                {
                    throw new ServerManagerDatabaseException('Database selection failed!', 502);
                }
                if (MySQLConfig::CHARSET)
                {
                    mysql_set_charset(MySQLConfig::CHARSET, $this->db);
                }
                $this->connected = true;
            }
        }
        
        /**
         *
         * @param string $query the query
         * @return mixed[] the fetched result of the query
         */
        protected function query($query)
        {
            $this->connect();
            $result = @mysql_unbuffered_query($query, $this->db);
            $resultdata = array();
            while (($row = mysql_fetch_array($result, MYSQL_ASSOC)))
            {
                $resultdata[] = $row;
            }

            return $resultdata;
        }

        /**
         *
         * @param string $query the query to execute
         * @return true on success, false on failure 
         */
        protected function queryExec($query)
        {
            $this->connect();
            return @mysql_query($query, $this->db);
        }
    }
    
    /**
     * 
     */
    class ServerDB extends Database
    {
        private static $instance = null;
        
        /**
         * 
         */
        private function __construct()
        {
            $this->init(/*dirname(__FILE__) . '/servers.db'*/);
        }
        
        /**
         * 
         */
        private function __clone()
        {}
        
        /**
         *
         * @return type 
         */
        public static function &instance()
        {
            if (self::$instance === null)
            {
                self::$instance = new self();
            }
            return self::$instance;
        }
        
        /**
         *
         * @param string $game the game
         * @param string $name the server
         * @return mixed[] the infos of the server 
         */
        public function getServer($game, $name)
        {
            $result = $this->query("SELECT * FROM servers WHERE game='$game' name='$name'");
            if (count($result) > 0)
            {
                return $result[0];
            }
            else
            {
                return false;
            }
        }
        
        /**
         *
         * @param string $game the game
         * @return mixed[][] the server of all servers with the given game 
         */
        public function getServersByGame($game)
        {
            $result = $this->query("SELECT * FROM servers WHERE game='$game'");
            if (count($result) > 0)
            {
                return $result;
            }
            else
            {
                return false;
            }
        }

        /**
         *
         * @return mixed[][] the server data of all servers
         */
        public function getAllServers()
        {
            $tmp = $this->query('SELECT game,name FROM servers ORDER BY game ASC');
            $servers = array();
            
            foreach ($tmp as $server)
            {
                $servers["{$server['game']}\\{$server['name']}"] = $server;
            }
            
            return $servers;
        }
        
        /**
         *
         * @param string $game the game
         * @param string $name the server
         * @return bool true on success, false on failure
         */
        public function addServer($game, $name)
        {
            $time = time();
            return $this->queryExec("INSERT INTO servers (pid, name, game, starttime, stoptime) VALUES (-1, '$name','$game', $time, 0)");
        }

        /**
         *
         * @staticvar array $PIDcache
         * @param string $game
         * @param string $name
         * @param int $pid
         * @return int the process ID of the server or false on failure
         */
        public function processID($game, $name, $pid = null)
        {
            static $PIDcache = array();

            if ($pid === null || !Util::is_numeric($pid))
            {
                if (isset($PIDcache["$game\\$name"]))
                {
                    return $PIDcache["$game\\$name"];
                }
                else
                {
                    $result = $this->query('SELECT pid FROM servers');
                    if (count($result) > 0)
                    {
                        $PIDcache = $result[0]['pid'];
                        return $result[0]['pid'];
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            else
            {
                return $this->queryExec("UPDATE servers SET pid=$pid WHERE game='$game' AND name='$name'");
            }
        }

        /**
         *
         * @param string $game the game
         * @param string $name the server
         * @return bool true on success, otherwise false
         */
        public function removeServer($game, $name)
        {
            return $this->queryExec("DELETE FROM servers WHERE game='$game' AND name='$name' LIMIT 1");
        }
    }

    /**
     * 
     */
    class Args
    {
        private static $instance = null;
    
        protected $argv;
        protected $argc;
        
        protected $params;
        protected $values;
        protected $command;
    
        /**
         * 
         */
        private function __construct()
        {
            $this->argv = $_SERVER['argv'];
            $this->argc = $_SERVER['argc'];
            
            $this->params = array();
            $this->values = array();
            $this->command = '';
            
            $this->readArgs();
        }
        
        /**
         * 
         */
        private function __clone()
        {}
        
        /**
         *
         * @return Args the instance of the Args class 
         */
        public static function &instance()
        {
            if (self::$instance === null)
            {
                self::$instance = new self();
            }
            return self::$instance;
        }
        
        /**
         * 
         */
        protected function readArgs()
        {
            $this->command = $this->argv[0];
            
            $lastCmd = null;
            for ($i = 1; $i < $this->argc; $i++)
            {
                if (substr($this->argv[$i], 0, 1) == '-')
                {
                    $arg = ltrim($this->argv[$i], '-');
                    if ($this->exists($arg))
                    {
                        $this->values[] =& $this->argv[$i];
                        continue;
                    }
                    $this->params[$arg] = array();
                    $lastCmd =& $this->params[$arg];
                }
                else
                {
                    if ($lastCmd !== null)
                    {
                        $lastCmd[] =& $this->argv[$i];
                        $this->values[] =& $this->argv[$i];
                    }
                    else
                    {
                        $this->values[] =& $this->argv[$i];
                    }
                }
                if (substr($this->argv[$i], 0, 2) == '--')
                {
                    $this->flags[substr($this->argv[$i], 2)] = true;
                }
            }
        }

        /**
         *
         * @param mixed $name the name (string) or the names (string[]) of the argument
         * @param bool $returnname whether to return the name
         * @return mixed true (bool) or the name (string) of the argument. False (bool) if none ex
         */
        public function exists($name, $returnname = false)
        {
            if (is_array($name))
            {
                foreach ($name as $entry)
                {
                    if (isset($this->params[$entry]))
                    {
                        return ($returnname ? $entry : true);
                    }
                }
            }
            else
            {
                if (isset($this->params[$name]))
                {
                    return ($returnname ? $name : true);
                }
            }
            return false;
        }
        
        /**
         *
         * @param mixed $name the name (string) or the names (string[]) of the argument
         * @param int $index the index of the argument to return (default: 0)
         * @param mixed $default the default value to return, if the argument does not exist
         * @return string the argument
         */
        public function getArg($name, $index = 0, $default = null)
        {
            $name = $this->exists($name, true);
            if ($name !== false && isset($this->params[$name][$index]))
            {
                return $this->params[$name][$index];
            }
            else
            {
                return $default;
            }
        }

        /**
         *
         * @param mixed $name the name (string) or names (string[]) of the argument
         * @return string[] the arguments or null if none exist
         */
        public function getArgsAll($name)
        {
            $name = $this->exists($name, true);
            if ($name !== false)
            {
                return $this->params[$name];
            }
            else
            {
                return null;
            }
        }
    }

    /**
     * 
     */
    class ServerManager
    {

        private static $instance = null;

        /**
         * 
         */
        private function __construct()
        {
            try
            {
                set_error_handler(array($this, 'error_handler'));
                set_exception_handler(array($this, 'exception_handler'));
                $this->checkDependencies();
                $this->syncDBandFS();
            }
            catch (Exception $e)
            {
                exit(1);
            }
        }

        /**
         * 
         */
        private function __clone()
        {}

        /**
         *
         * @return ServerManager the instance of the manager 
         */
        public static function &instance()
        {
            if (self::$instance === null)
            {
                self::$instance = new self();
            }
            return self::$instance;
        }
        
        /**
         * 
         * @return AbtractCommand the command
         */
        protected function getCommand()
        {
            $command = Args::instance()->getArg(array('c', 'command'), 0, 'help');
            $command = ucfirst(strtolower(trim($command))) . 'Command';
            
            if (!class_exists($command))
            {
                $command = 'help';
                $command = 'HelpCommand';
            }
            if (!in_array('AbstractCommand', class_parents($command)))
            {
                throw new ServerManagerException("ServerManager::routeCommand(): Couldn't find a valid command.");
            }
            
            return new $command();
        }
        
        /**
         * 
         */
        public function execute()
        {
            $command = $this->getCommand();
            if ($command->run() === false)
            {
                throw new ServerManagerException("ServerManager::execute(): Command returned false!");
            }
        }
        
        /**
         *
         * @return bool true if the current user is root, otherwise (on windows always) false
         */
        public function userIsRoot()
        {
            if (__WINDOWS)
            {
                return false;
            }
            else
            {
                $name = Util::exec("whoami");
                $name = trim(implode('', $name[0]));
                if ($name == 'root')
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        
        /**
         * 
         */
        protected function checkDependencies()
        {
            if (__WINDOWS)
            {
                
            }
            else
            {
                $which = Util::exec('which 7z');
                $which = trim($which[0]);
                if (empty($which))
                {
                    throw new ServerManagerException('ServerManager::checkDependencies(): 7-Zip not found!');
                }
                
                $which = Util::exec('which screen');
                $which = trim($which[0]);
                if (empty($which))
                {
                    throw new ServerManagerException('ServerManager::checkDependencies(): Screen not found!');
                }
            }
        }
        
        /**
         * teh error handler
         *
         * @access public
         * @static
         * @param int $errno
         * @param string $errstr
         * @param string $errfile
         * @param int $errline
         * @param array $errcontext
         */
        public function error_handler($errno, $errstr, $errfile, $errline, $errcontext)
        {
            if (error_reporting() == 0)
            {
                return;
            }
            $errstr = strip_tags($errstr);
            $errfile = (isset($errfile) ? basename($errfile) : 'unknown');
            $errline = (isset($errline) ? $errline : 'unknown');

            $errortype = $this->getErrorTypeStr($errno);
            
            Logger::write("PHP:$errortype", '[' . $errfile . ':' . $errline . '] ' . $errstr);
        }

        /**
         *
         * @param int $errno the error number
         * @return string the error type
         */
        public function getErrorTypeStr($errno)
        {
            switch ($errno)
            {
                case E_ERROR:
                    $errortype = 'error';
                    break;
                case E_WARNING:
                    $errortype = 'warning';
                    break;
                case E_NOTICE:
                    $errortype = 'notice';
                    break;
                case E_STRICT:
                    $errortype = 'strict';
                    break;
                case E_DEPRECATED:
                    $errortype = 'deprecated';
                    break;
                case E_RECOVERABLE_ERROR:
                    $errortype = 'recoverable error';
                    break;
                case E_USER_ERROR:
                    $errortype = 'usererror';
                    break;
                case E_USER_WARNING:
                    $errortype = 'user warning';
                    break;
                case E_USER_NOTICE:
                    $errortype = 'user notice';
                    break;
                case E_USER_DEPRECATED:
                    $errortype = 'user deprecated';
                    break;
                default:
                    $errortype = 'unknown';
            }
            return $errortype;
        }

        /**
         * the exception handler
         *
         * @access public
         * @static
         * @param Exception $e
         */
        public function exception_handler($e)
        {
            $type = get_class($e);
            Logger::write("Uncaught:$type", '[' . basename($e->getFile()) . ':' . $e->getLine() . '] ' . $e->getMessage());
        }

        /**
         * 
         */
        protected function syncDBandFS()
        {
            $db = ServerDB::instance();
            $serversDB = $db->getAllServers();
            $serversFS = array();
            $this->getServersFromFS($serversFS);
            
            foreach ($serversDB as $name => &$server)
            {
                //echo "Server: $name\n";
                
                if (!isset($serversFS[$name]))
                {
                    $db->removeServer($server['game'], $server['name']);
                }
            }
            
            foreach ($serversFS as $name => &$server)
            {
                //echo "Server: $name\n";
                
                if (!isset($serversDB[$name]))
                {
                    $db->addServer($server['game'], $server['name']);
                }
            }
            
        }

        /**
         *
         * @staticvar int $recursionlevel
         * @staticvar string $game
         * @param string[] $output the
         * @param string $dir the directory to read (default: "(script directory)/servers")
         */
        protected function getServersFromFS(&$output, $dir = SERVERDIR)
        {
            static $recursionlevel = 0;
            static $game = '';
            $recursionlimit = 2;

            $recursionlevel++;
            $h = opendir($dir);
            while (($entry = readdir($h)))
            {
                if (!Util::matches('/^\.\.?$/', $entry))
                {
                    $path = $dir . DS . $entry;
                    if (is_dir($path))
                    {
                        if ($recursionlevel == 1)
                        {
                            $game = $entry;
                            $this->getServersFromFS($output, $path);
                        }
                        else
                        {
                            $output["$game\\$entry"] = array('game' => $game, 'name' => $entry);
                        }
                    }
                }
            }
            closedir($h);
            $recursionlevel--;
        }

        /**
         *
         * @param string the game name
         * @return string the package path
         */
        protected function getPackage($game)
        {
            $package = PACKAGEDIR . DS . "$game.7z";
            if (file_exists($package))
            {
                return $package;
            }
            else
            {
                throw new ServerManagerException('ServerManager::getPackage(1): Package does not exist!');
            }
        }
        
        /**
         *
         * @param string the full name
         * @return bool true if the server exists, otherwise false
         */
        public function gameserverExists($name)
        {
            try
            {
                $name = Util::parseName($name);
            }
            catch (Exception $e)
            {
                return false;
            }

            if (!ServerDB::instance()->getServer($name[0], $name[1]))
            {
                return false;
            }
            
            if (!file_exists(SERVERDIR . "/{$name[0]}/{$name[1]}"))
            {
                return false;
            }
            
            return true;
        }

        /**
         *
         * @param type $game
         * @return string 
         */
        protected function createGameserverDir($game, $name)
        {
            if (!file_exists(SERVERDIR))
            {
                mkdir(SERVERDIR, 0766);
            }
            if (!is_writable(SERVERDIR))
            {
                chmod(SERVERDIR, 0766);
                if (!is_writable(SERVERDIR))
                {
                    throw new ServerManagerException('ServerManager::createGameserverDir(2): The server directory is not writable!');;
                }
            }

            $gamedir = SERVERDIR . DS . $game;
            if (!file_exists($gamedir))
            {
                mkdir($gamedir, 0766);
            }
            if (!is_writable($gamedir))
            {
                chmod($gamedir, 0766);
                if (!is_writable($gamedir))
                {
                    throw new ServerManagerException('ServerManager::createGameserverDir(2): The game directory is not writable!');;
                }
            }
            
            $gameserverdir = $gamedir . DS . $name;
            if (file_exists($serverdir))
            {
                throw new ServerManagerException('ServerManager::createGameserverDir(2): Gameserver directory already exists!');
            }
            else
            {
                mkdir($gameserverdir, 0766);
            }
            if (!is_writable($gameserverdir))
            {
                chmod($gameserverdir, 0766);
                if (!is_writable($gamedir))
                {
                    throw new ServerManagerException('ServerManager::createGameserverDir(2): The gameserver directory is not writable!');;
                }
            }
            
            return $gameserverdir;
        }

        /**
         *
         * @param type $game
         * @param type $name
         * @return type 
         */
        public function create($name)
        {
            try
            {
                $name = Util::parseName($name);
                $package = $this->getPackage($name[0]);
                $path = $this->createGameServerDir($name[0], $name[1]);
            }
            catch (ServerManagerException $e)
            {
                return false;
            }
            
            $cmd = '7z x "-o' . $path . '" "' . $package. '"';
            $result = Util::exec($cmd);
            if ($result[1] === 1)
            {
                return false;
            }
            
            if (!ServerDB::instance()->addServer($name[0], $name[1]))
            {
                unlink($path);
                return false;
            }
            
            return true;
        }
        
        /**
         *
         * @param type $name
         * @return type 
         */
        public function getStatus($name)
        {
            try
            {
                $name = Util::parseName($name);
            }
            catch (Exception $e)
            {
                return false;
            }

            $server = ServerDB::instance()->getServer($name[0], $name[1]);
            if ($server === null)
            {
                throw new ServerManagerException("ServerManager::getStatus(1): Server does not exist in database!", 404);
            }

            if ($server['pid'] === -1)
            {
                return false;
            }

            return Util::processRunning($server['pid']);
        }
    }

    /**
     * 
     */
    abstract class AbstractCommand
    {
        /**
         * 
         */
        public abstract function run();
    }
    
    /**
     * 
     */
    class HelpCommand extends AbstractCommand
    {
        /**
         *
         * @return bool true on success or false on failure
         */
        public function run()
        {
            Util::println(<<<manual

ServerManager - Manual

Hier kommen infos zu den commands hin :D (paramter, aliase, ...)
manual
);
            return true;
        }
    }
    
    /**
     * 
     */
    class InstallCommand extends AbstractCommand
    {
        /**
         * 
         */
        public function run()
        {
            $name = Args::instance()->getArg(array('n', 'name'), 0);
            if ($name === null)
            {
                Util::println("{RED}The name is missing.");
                return false;
            }
            if (ServerManager::instance()->create($name))
            {
                Util::println("{GREEN}The server has been successfully installed and should be ready to start.");
            }
            else
            {
                Util::println("{RED}The server could not be installed. Check the error messages and try again.");
            }
        }
    }
    
    // DEBUG
    if (!Proc::factory('httpd.exe')->isRunning())
    {
        Logger::write("Notice", "Starting Apache Server for PHPMyAdmin");
        Util::exec('\xampp\xampp_cli.exe start apache');
    }
    
    if (!Proc::factory('mysqld.exe')->isRunning())
    {
        Logger::write("Notice", "Starting MySQL Server");
        Util::exec('\xampp\xampp_cli.exe start mysql');
    }
    
    chdir(__DIR__);
    // /DEBUG

    Util::println("{YELLOW}Executing ServerManager");
    ServerManager::instance()->execute();
    Util::println("{RED}Done");
    echo "\n\n";
    
    /*
     * 
     * - Help
     * - Version
     * - Start
     * - Stop
     * - Restart
     * - List
     * - Install
     * - Remove
     * - Backup
     * - View ?
     * - Status
     * - Cron
     * 
     */
    
    /*
     * 
     * Name:
     *      - name => *.name
     *      - .name => *.name
     *      - game => *.name
     *      - game. => game.*
     * 
     * 
     */
    
?>

