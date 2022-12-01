# Webserver log parser

## Input:
* receives a log as argument (e.g. webserver.log)

## Output:
* list of webpages with most page views ordered from most pages views to less page views
* can lists unique visits

### Instalation:
```
bundle install
chmod +x parser.rb
```
### Tests:
`rspec`

### Usage:
```
usage ./parser <path>[,<path>...]
    -o <output_path> - specified output file
    -u - unique value
    -h - this message
```

`./parser.rb webserver.log`
webserver.log is test file provided in the repo

Specifing output file we can save output to file
Adding `-u` shows unique visits

#### Input:
```
/contact 802.683.925.780
/help/1 802.683.925.780
/help/1 777.4.3.1
```

#### Output:
```
/help/1 2 visits
/contact 1 visit
```

With `-u` modifier:
#### Output:
```
/help/1 2 unique visits
/contact 1 unique visit
```
