# Sensu plugin for monitoring DNS resolution

A sensu plugin to monitor DNS resolution.

## Usage

The plugin accepts the following command line options:

```
Usage: check-dnslookup.rb (options)
    -d, --domain <DOMAIN>            Domain to look up (required)
    -s, --server <SERVER>            Comma separated list of name server(s) for resolution
        --timeout <SECONDS>          DNS lookup timeout (default: 3)
    -t, --type <TYPE>                Record type (default: A)
    -w, --warn                       Warn instead of throwing a critical failure
```

## Author
Matteo Cerutti - <matteo.cerutti@hotmail.co.uk>
