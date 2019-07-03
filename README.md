# `xcresultviewer`
A simple command line utility to convert `.xcresults` to a web page to understand what failed or how to optimize parallel UI tests.

## Overview

When UI tests randomly fail on CI it can be really hard to trace back what happened to cause it.

`xcresultviewer` takes an `.xcresult` bundle and converts it into a web page so you can see the activities and screenshots and easily follow the flow the app took before the test failed.

`xcresultviewer` can also analyze an xcresult bundle to help you optimize your parallel UI tests.

## Usage

### General usage

- Download the [latest release](https://github.com/KaneCheshire/xcresultviewer/releases/latest)
- In Terminal, navigate to where the utility is located
- Run `./xcresultviewer <options> '<path to an .xcresult bundle (usually located in derived data)>'`

Watch out for spaces in the path name.

### Just viewing failures

To simply view any failures as a web page in an xcresult you can just pass a path to an xcresult bundle without any options:

```
./xcresultviewer '<path to an .xcresult bundle>'
```

`xcresultviewer` only shows tests that failed and matches up automatic screenshots with activities so you can follow the flow (in reverse).

### Skipping opening a browser

If you don't want `xcresultviewer` to automatically open a browser after generating the html page, pass the `-s` flag:

```
./xcresultviewer -s '<path to an .xcresult bundle>'
```
or
```
./xcresultviewer --skip-open-browser '<path to an .xcresult bundle>'
```

### Analyzing xcresults to optimize parallel tests

If you're more interested in learning how to optimize and speed up your parallel tests you can
pass the `-a` flag instead:

```
./xcresultviewer -a '<path to an .xcresult bundle>'
```
or
```
./xcresultviewer --analyze '<path to an .xcresult bundle>'
```

## Suggestions?

`xcresultviewer` is in early prototype stage so I welcome suggestions and contributions!
