# Contributing to the google maps webservice

### What you will need
- A Linux, Mac OS X, or Windows machine (note: to run and compile iOS specific parts you'll need access to a Mac OS X machine);
- git (used for source version control, installation instruction can be found [here][git]);
- Set up Dart SDK (installation instructions can be found [here][dart])
- The Flutter SDK (installation instructions can be found [here][flutter]);
- A personal GitHub account (if you don't have one, you can sign-up for free [here][github])

### Setting up your development environment
- Fork https://github.com/lejard-h/google_maps_webservice.git into your own GitHub account. If you already have a fork and moving to a new computer, make sure you update you fork.
- If you haven't configured your machine with an SSH key that's known to github, then follow [GitHub's directions][git-ssh] to generate an SSH key.
- Clone your forked repo on your local development machine:
  ```sh
    git clone git@github.com:<your_name_here>/google_maps_webservice.git
  ``` 
- Change into the google_maps_webservice directory: 
  ```sh
     cd google_maps_webservice
  ```
- Add an upstream to the original repo, so that fetch from the master repository and not your clone:
  ```sh
      git remote add upstream git@github.com:lejard-h/google_maps_webservice.git
  ```     

### Running the example project     

- Change into the example directory: 
  ```sh
   cd example 
   export API_KEY="YOUR_KEY"
   
   dart directions.dart
   dart geolocation.dart
   dart places_autocomplete.dart
   ```

  
### Contribute
We really appreciate contributions via GitHub pull requests. To contribute take the following steps:

- Make sure you are up to date with the latest code on the master:
  ```sh
     git fetch upstream
     git checkout upstream/master -b <name_of_your_branch>
  ```     
- Apply your changes
- Verify your changes and fix potential warnings/ errors:
  ```sh
  dartfmt -w .
  dartanalyzer .
  pub run test
  ```
 - Commit your changes:
   ```sh
     git commit -am "<your informative commit message>"
   ```
 - Push changes to your fork:
   ```sh
     git push origin <name_of_your_branch>
   ```

### Send us your pull request:

Go to https://github.com/lejard-h/google_maps_webservice and click the "Compare & pull request" button.


Please make sure you solved all warnings and errors reported by the static code analyses and that you fill in the full pull request template. Failing to do so will result in us asking you to fix it.

    


   [git]:<https://git-scm.com/>
   [flutter]:<https://flutter.dev/docs/get-started/install>
   [github]:<https://github.com/>
   [git-ssh]:<https://help.github.com/articles/generating-ssh-keys/>
   [git-repo-url]: <https://github.com/lejard-h/google_maps_webservice.git>
   [dart]:<https://www.dartlang.org/tools/sdk>
