PasswordValidator = {
    validatePassword: function(element) {
        var password = element.value;
        var isPasswordValid = this.doesPasswordMeetPardotStandards(password);
        var passwordTooWeakLabel = window.getElementByIdCS("password-too-weak-label");

        if (isPasswordValid) {
            passwordTooWeakLabel.innerHTML = "Good";

            // Change border and text to green
            passwordTooWeakLabel.style.color = "#4bca81";
            element.style.borderColor = "#4bca81";
        } else {
            passwordTooWeakLabel.innerHTML = "Too weak";

            // Change border and text to red
            passwordTooWeakLabel.style.color = "#c23934";
            element.style.borderColor = "#c23934";
        }
    },
    doesPasswordMeetPardotStandards: function(password) {
        if (password.length > 30) {
            return false;
        }

        // Password must include an uppercase/lowercase letter and a number
        var regex = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,30}$/;
        return regex.test(password);
    }
};
