---
editor_options: 
  markdown: 
    wrap: 72
---

## Release version 1.0.0

## R CMD check results

0 errors \| 0 warnings \| 1 note

-   This is a new release.

## Release version 1.1.0

I have followed the resubmission instructions from here
<https://r-pkgs.org/release.html>.

My development computer is running Ubuntu 24.04.

## Test 1: R CMD check results

0 errors \| 0 warnings \| 0 notes

## Test 2: Spell Check

`devtools::spell_check()` returns no legitimate spelling errors

## Test 3: Goodpractice

I run `goodpractice::gp()` succesfully with the following message

```         
♥ Ole! Groundbreaking package! Keep up the finest work!
```

## Test 4: Check

On running: `devtools::check(remote = TRUE, manual = TRUE)`

I receive the following notes:

❯ checking CRAN incoming feasibility ... [7s/50s] NOTE Maintainer:
‘David Hammond
[anotherdavidhammond\@gmail.com](mailto:anotherdavidhammond@gmail.com){.email}’

Days since last update: 6

It is assumed this can be ignored

❯ checking HTML version of manual ... NOTE Skipping checking HTML
validation: no command 'tidy' found

The second note has been suggested not to be an issue.
<https://stackoverflow.com/questions/74857062/rhub-cran-check-keeps-giving-html-note-on-fedora-test-no-command-tidy-found>

## Test 5: Windows

On running:

`devtools::check_win_devel()`

I receive this note again

❯ checking CRAN incoming feasibility ... [7s/50s] NOTE Maintainer:
‘David Hammond
[anotherdavidhammond\@gmail.com](mailto:anotherdavidhammond@gmail.com){.email}’

Days since last update: 6

It is assumed this can be ignored

## Test 6: Mac

On running:

`devtools::check_mac_release()`

I receive no errors.

## Test 7: Rhub

All `rhub::rhub_check()` are successful except for:

-   `intel` Issue Error in dyn.load(file, DLLpath = DLLpath, ...) :
    unable to load shared object
    '/github/home/R/x86_64-pc-linux-gnu-library/4.5/classInt/libs/classInt.so':

    -   Ignoring as this seems to be a container issue
        <https://stackoverflow.com/questions/38943764/r-error-in-dyn-loadfile-dllpath-dllpath>

-   `rchk` Error: bcheck output file does not exist

    -   Ignoring again as this seems a container issue.

        libgfortran.so.5: cannot open shared object file: No such file
        or directory
