# `xcresultviewer`
A simple command line utility to convert `.xcresults` to a web page to understand what failed.

## Intro

When UI tests randomly fail on CI it can be really hard to trace back what happened to cause it. 

`xcresultviewer` takes an `.xcresult` bundle and converts it into a web page so you can see the activities and screenshots and easily follow the flow the app took before the test failed.

## Usage

- Download, fork or clone the repo
- Compile and export the command line utility
- In Terminal, navigate to where the utility is located
- Run `./xcresultviewer '<path to an .xcresult bundle (usually located in derived data)>'`

`xcresultviewer` only shows tests that failed and matches up automatic screenshots with activities so you can follow the flow.

## Suggestions?

`xcresultviewer` is in early prototype stage so I welcome suggestions and contributions!
