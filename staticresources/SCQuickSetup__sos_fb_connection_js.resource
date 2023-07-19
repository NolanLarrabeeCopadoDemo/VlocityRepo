/**
 * FirebaseManager
 * Retrieve and save data to Firebase.
 */

var FirebaseManager = (function () {
  var instance;

  function FirebaseManager(){
    var FB_DEFAULT_SETTINGS_PATH = "default";
    var FB_DEFAULT_IMAGES_PATH = "defaultSupportHomeImages";
    var KBDeploymentsPath = "KBDeployments";

    this.lastSettingsData = null; // Settings object
    this.firebaseUser = null; // FIRDatabaseReference?

    // Initialize Firebase
    // var config = {
    //   apiKey: "AIzaSyDU9f2KomHmFnOQ6rqhGxiQoOG8G9LeW2I",
    //   authDomain: "crackling-inferno-2200.firebaseapp.com",
    //   databaseURL: "https://crackling-inferno-2200.firebaseio.com",
    //   storageBucket: "crackling-inferno-2200.appspot.com",
    // };

    var config = {
      apiKey: "AIzaSyBv2niJzp__io8nqlHD5YjRuI-LHWudEiw",
      authDomain: "release-crackling-inferno.firebaseapp.com",
      databaseURL: "https://release-crackling-inferno.firebaseio.com",
      storageBucket: "release-crackling-inferno.appspot.com",
    };
    firebase.initializeApp(config);

    var defaultImages = getDefaultImages(); // initialize firebase must be called first

    // TO DO: Move error messages to another file
    var error_data_not_saved_msg            = "Error saving data";
    var error_data_not_removed_msg          = "Error removing data";
    var data_saved_message                  = "Data saved successfully";
    var data_removed_msg                    = "Firebase.data_removed";
    var error_creating_user_msg             = "Error when creating user.";
    var error_getting_default_settings_msg  = "FB error getting default values";

    //-------------------------------------------------------------------------
    //-------------------------------------------------------------------------
    // Private functions

    /**
     * Get default settings, to initialize a new user.
     * @return {Promise}  Returns when having default values from FB.
     *                    Resolves with a JSON with the defaults.
     */
    function getDefaultSettings() {
      var defaultRef = firebase.database().ref("/" + FB_DEFAULT_SETTINGS_PATH);

      var promise = new Promise(function(resolve, reject) {
        defaultRef.once('value').then(function(snapshot) {
            resolve(snapshot.val());
          }).catch(function(error){
            reject(error_getting_default_settings_msg + error);
          });
      });
      return promise;
    }

    /**
     * Get default image set from FB, and set it in defaultImages private variable.
     */
    function getDefaultImages() {
      // Get default images
      var defaultImagesRef = firebase.database().ref(FB_DEFAULT_IMAGES_PATH);

      defaultImagesRef.once('value').then(function(snapshot) {
        if(snapshot.exists()) {
          defaultImages = snapshot.val();
        } else {
          defaultImages = [];
        }
      }).catch(function(error) {
        defaultImages = [];
      });
    }

    /**
       * Get firebase reference for given user.
       * The user may not exists in FB yet, in which case it is a potential reference.
       * @param  {string} email User email
       * @return {FBRef}  FB reference to that user
       */
      function getUserFBRef(email) {
        var emailHash = CryptoJS.SHA256(email).toString(CryptoJS.enc.Hex);
        return firebase.database().ref("/" + emailHash);
      }

    //-------------------------------------------------------------------------
    //-------------------------------------------------------------------------
    // Public methods
    return {
      /**
       * Returns a promise, that resolves to the data associated with the given
       * email if it exists on FireBase, or rejects with an error.
       *
       * @param  {string} email User email of the desired settings.
       * @return {Promise}      Resolves with the user's settings object
       *                        or rejects with user not found error, when FB call
       *                        returns.
       */
      login: function(email) {
        this.firebaseUser = getUserFBRef(email);
        var fb = this;

        var promise = new Promise(function(resolve, reject) {
          // Listen just once to firebse, to check if user exists.
          fb.firebaseUser.once('value').then(function(snapshot) {
            if(!snapshot.exists()) {
              // User does not exist
              fb.firebaseUser = null;
              reject(new FirebaseUserNotFound());
            } else {
              // User already exists
              fb.lastSettingsData = snapshot.val();
              resolve(fb.lastSettingsData);
            }
          });
        });
        return promise;
      },

      /**
       * Logout user from fb sync.
       */
      logout: function() {
        this.firebaseUser = null;
      },

      /**
       * Create a new user in FB
       * Do not call if the user already exists in FB, or it will be overwritten.
       * @param  {string} email   Email of the new user
       * @return {Promise}        Returns when set in FB is finished.
       *                          Resolves with the user's settings object
       *                          or rejects with user not found error
       */
      createUser:  function(email) {
        this.firebaseUser = getUserFBRef(email);
        var fb = this;

        var promise = new Promise(function(resolve, reject) {

          getDefaultSettings().then( function(defaultSettings) {
            fb.firebaseUser.set(defaultSettings)
              .then(function(){
                fb.lastSettingsData = defaultSettings;
                resolve(fb.lastSettingsData);
              })
              .catch(function(error){
                fb.firebaseUser = null;
                reject(new FirebaseOperationFailed(error_creating_user_msg));
              });
          })
          .catch(function(error){
            reject(error);
          });
        });
        return promise;
      },

      /**
       * Create an object into firebase
       * The user must be logged in.
       * @param  {string} path            Relative path (to current user) where
       *                                  the new object must be put.
       * @param  {json} valuesToCreate    Values to new object.
       * @return {Promise}                Resolves with the new object id or rejects
       *                                  when data is saved or not into FB.
       * @throws {FirebaseUserNotLoggedIn}  If user is not logged in.
       */
      createObject: function(path, valuesToCreateJson) {
        if (!this.firebaseUser) {
          throw new FirebaseUserNotLoggedIn();
        }
        var valuesToCreate = JSON.parse(valuesToCreateJson);
        var newObjectRef = this.firebaseUser.child(path).push();// generates a unique id

        if (path == KBDeploymentsPath) {
          valuesToCreate.supportHomeImages = defaultImages;
        }

        var promise = new Promise(function(resolve, reject) {
          newObjectRef.set(valuesToCreate).then(function() {
            //
            //TO DO: Add to last setting data
            resolve(newObjectRef.key); // autogenerated (by FB) id
          }).catch(function(error) {
            reject(new FirebaseOperationFailed(error_data_not_saved_msg));
          });
        });
        return promise;
      },

      /**
       * Save a current option change.
       * The user must be logged in.
       * @param  {string} key   Current setting name.
       * @param  {string} value New value for that current setting.
       * @return {Promise}      Resolved when firebase persist data.
       * @throws {FirebaseUserNotLoggedIn}  If user is not logged in.
       */
      saveCurrent: function(key, value) {
        if (!this.firebaseUser) {
          throw new FirebaseUserNotLoggedIn();
        }

        var promise = new Promise(function(resolve, reject) {
          this.firebaseUser.child(key).set(value).then( function() {
            // Data saved successfully
            resolve(data_saved_message);
          }).catch( function(error) {
            // Data could not be saved
            reject(new FirebaseOperationFailed(error_data_not_saved_msg));
          });
        });
        return promise;
      },

      /**
       * Update an object into firebase
       * The user must be logged in.
       * @param  {string} path           Relative path (to current user) to the
       *                                 object, that is, the object type
       *                                 followed by a slash and the object id.
       *                                 Ex: "KBDeployments/kbId"
       * @param  {json}   valuesToUpdate Dictonary with fields of
       *                                  objectEditable to edit.
       * @return {Promise}               Resolved when FB update finish.
       * @throws {FirebaseUserNotLoggedIn}  If user is not logged in.
       */
      updateObject: function(path, valuesToUpdateJSON) {
        if (!this.firebaseUser) {
          throw new FirebaseUserNotLoggedIn();
        }

        //var valuesToUpdate = SettingSerializer.deformatObject(valuesToUpdateJSON);
        var fb = this;

        var promise = new Promise(function(resolve, reject) {
         // fb.firebaseUser.child(path).update(valuesToUpdate).then( function() {
           fb.firebaseUser.child(path).update(valuesToUpdateJSON).then( function() {
            // Data saved successfully
            resolve(data_saved_message);
          }).catch( function(error) {
            // Data could not be saved
            reject(new FirebaseOperationFailed(error_data_not_saved_msg));
          });
        });
        return promise;
      },

      /**
       * Deletes an object for current user
       * The user must be logged in.
       * @param  {string} path            Relative path (to current user) to the
       *                                  object, that is, the object type followed by a
       *                                  slash and the object id.
       *                                  Ex: "KBDeployments/kbId"
       * @return {Promise}                Deletes object from specified path in FB.
       * @throws {FirebaseUserNotLoggedIn}  If user is not logged in.
       */
      deleteObject: function(path) {
        if (!this.firebaseUser) {
          throw new FirebaseUserNotLoggedIn();
        }

        var fb = this;
        var promise = new Promise(function(resolve, reject) {
          fb.firebaseUser.child(path).remove().then( function() {
            // Data saved successfully
            resolve(data_removed_msg);
          }).catch( function(error) {
            // Data could not be saved
            reject(new FirebaseOperationFailed(error_data_not_removed_msg));
          });
        });
        return promise;
      }
    };
  }

  return {
      sharedInstance: function () {
          if (!instance) {
              instance = new FirebaseManager();
              // Hide the constructor so the returned objected can't be new'd...
              instance.constructor = null;
          }
          return instance;
      }
  };
})();


//=============================================================================
//=============================================================================
//=============================================================================


// Firebase errors

// TO DO: Move error messages to another file.
var userNotLoggedInMsg  = "User is not logged in.";
var userNotFoundMsg     = "User not found.";
var operationFailedMsg  = "Firebase operation failed.";

function FirebaseUserNotLoggedIn(message) {
  this.name = "FirebaseUserNotLoggedIn";
  this.message = (message || userNotLoggedInMsg);
}
FirebaseUserNotLoggedIn.prototype = Error.prototype;

function FirebaseUserNotFound(message) {
  this.name = "FirebaseUserNotFound";
  this.message = (message || userNotFoundMsg);
}
FirebaseUserNotFound.prototype = Error.prototype;

function FirebaseOperationFailed(message) {
  this.name = "FirebaseOperationFailed";
  this.message = (message || operationFailedMsg);
}
FirebaseUserNotFound.prototype = Error.prototype;

