//var PasswordRater = (function() {

    var lowercaseLetterRegex = /[a-z]/g;
    var uppercaseLetterRegex = /[A-Z]/g;
    var numberRegex = /[0-9]/g;
    var specialCharRegex = /[^a-zA-Z0-9]/g;

    var rate = function(password, verbose)
    {
        var score = password.length * 1; // multiplizieren?
    
        // unnötig?
        var lcLetters       = password.match(lowercaseLetterRegex) || [];
        var ucLetters       = password.match(uppercaseLetterRegex) || [];
        var numbers         = password.match(numberRegex) || [];
        var specialChars    = password.match(specialCharRegex) || [];
        // ---
        
        var lcLetterShare       = lcLetters.length / password.length;
        var ucLetterShare       = ucLetters.length / password.length;
        var numberShare         = numbers.length / password.length;
        var specialCharShare    = specialChars.length / password.length;

        if (verbose)
        {
            alert(
                "Length: " + password.length + "\n" +
                "Shares:\n" +
                "    lcLetters: " + lcLetterShare + "\n" +
                "    ucLetters: " + ucLetterShare + "\n" +
                "    numbers: " + numberShare + "\n" +
                "    specialChars: " + specialCharShare
            );
        }

        var BASE = 2;
        var EXP_BASE = 1;

        
        if (lcLetterShare > 0)
        {
            //score *= 1 + lcLetterShare;
            score *= Math.pow(BASE, EXP_BASE - lcLetterShare);
        }
        
        if (ucLetterShare > 0)
        {
            //score *= 1 + ucLetterShare;
            score *= Math.pow(BASE, EXP_BASE - ucLetterShare);
        }
        
        if (numberShare > 0)
        {
            //score *= 1 + numberShare;
            score *= Math.pow(BASE, EXP_BASE - numberShare);
        }
        
        if (specialCharShare > 0)
        {
            //score *= 1 + specialCharShare;
            score *= Math.pow(BASE, EXP_BASE - specialCharShare);
        }
        return Math.min(Math.max(0, Math.round(score)), 100);
    }

//})();
