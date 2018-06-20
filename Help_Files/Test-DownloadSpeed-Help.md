---
schema: 2.0.0
external help file: Test-DownloadSpeed-Help.xml
---
# Test-DownloadSpeed

## SYNOPSIS

Tests the current download speed using Speedtest.net and writes it to `stdout`.

## DESCRIPTION

Uses the Speedtest.net service to test the current download speed by executing a
test against the four closest servers and returning the fastest result.

## EXAMPLES

### Base Usage

The file contains two functions, however only one of them should be used, and
that's the `Test-DownloadSpeed` function. This one will call the `DownloadSpeed`
function as needed in order to perform the test.
