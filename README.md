# `xcresultviewer`
A simple command line utility to convert `.xcresult`s to a web page to understand what failed or how to optimize parallel UI tests.

> NOTE: In previous versions you would run with `./xcresultviewer`, now you run with `./xcrv` which is much easier to type.

## Overview

When UI tests randomly fail on CI it can be really hard to trace back what happened to cause it.

By default, `xcresultviewer` takes an `.xcresult` bundle and converts it into a web page so you can see the activities and screenshots and easily follow the flow the app took before the test failed.

`xcresultviewer` can also analyze an xcresult bundle to help you optimize your parallel UI tests.

## Usage

### General usage

- Download the [latest release](https://github.com/KaneCheshire/xcresultviewer/releases/latest)
- In Terminal, navigate to where the utility is located
- Run `./xcrv <options> '<path to an .xcresult bundle (usually located in derived data)>'`

Watch out for spaces in the path name.

### Just viewing failures

To simply view any failures as a web page in an xcresult you can just pass a path to an xcresult bundle without any options:

```
./xcrv '<path to an .xcresult bundle>'
```

`xcresultviewer` only shows tests that failed and matches up automatic screenshots with activities so you can follow the flow (in reverse).

### Skipping opening a browser

If you don't want `xcresultviewer` to automatically open a browser after generating the html page, pass the `-s` flag:

```
./xcrv -s '<path to an .xcresult bundle>'
```
or
```
./xcrv --skip-open-browser '<path to an .xcresult bundle>'
```

### Analyzing xcresults to optimize parallel tests

If you're more interested in learning how to optimize and speed up your parallel tests you can
pass the `-a` flag instead:

```
./xcrv -a '<path to an .xcresult bundle>'
```
or
```
./xcrv --analyze '<path to an .xcresult bundle>'
```

## Suggestions?

`xcresultviewer` is in early prototype stage so I welcome suggestions and contributions!
