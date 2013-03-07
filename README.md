# Paperless Automation Tool for Mac OS X

Paperless is command-line tool that will help you automate your paperless workflow from your scanner to your e-filing cabinet. Paperless analyzes your scanned documents and processes them through a set of user defined rules. These rules determine how and where to file the document. The entire process is entirely automated so that all you need to do is press the scan button on your scanner!

While you can run Paperless directly from the command-line (via Terminal.app), it would work best if it were combined with an application like [Hazel](http://www.noodlesoft.com/hazel.php) or [folder actions](http://www.macworld.com/article/1167157/automate_tasks_with_folder_actions.html). If your scanner is configured to place a document directly into a folder ([ScanSnap](http://www.amazon.com/dp/B00ATZ9QMO/?tag=joeworkmannet-20) is awesome), these tools can automatically launch Paperless to tag and process your document so that you never have to look at it again. (Well until you need to actually find it.)

Paperless can integrate with the following applications:

**Document OCR**:

* PDFPen
* PDFPenPro
* DEVONThink Pro

**Archive/Storage Apps**:

* Finder
* Evernote
* DEVONThink Pro 

## Prerequisites

The core of Paperless does not require OS X. However, all of the integrations are developed to use applications that run on OS X. Therefore, as the project currently stands, you will need to be running OS X. 

Paperless was developed and fully tested using Ruby v1.9.3. It has not been verified to using older versions of ruby. OS X ships with ruby v1.8.7. This means that you will need to install your own version of ruby. 

I recommend that you install [RVM](https://rvm.io). Its makes it really simple to manage ruby installs. You also will not need to worry about any OS X updates messing things up. 


## Installation

Paperless if pretty easy to install once you have the proper environment built mentioned in the prerequisites. Its just a gem command away...

1. Install it via the gem command in terminal:

    `$ gem install paperless`

2. You can now execute it:

    `$ paperless help`

3. Setup the config file:

    `$ paperless initconfig`

4. Edit the config file and add your customizations:

    `$ paperless editconfig`

### Installing Updates

Since Paperless is a ruby gem, you can use the standard methodology to obtain updates. 

    $ gem update paperless

## Usage

Here is an overview of the options available to paperless along with some helpful examples. See below for how to set these values using a `.paperless.rc` config file.

### Accessing Help

To access paperless help run the following command:

    $ paperless help

Paperless has different commands (see below). You can access the help for each command by typing the command after the help command like so:

    $ paperless help create

### Command Modes

Paperless has the following command modes. You can always access the the help for each command via command line: `$ paperless help <command>`

#### create

    NAME
        create - Create a new note from a file.
    
    SYNOPSIS
        paperless [global options] create [command options] file_name
    
    COMMAND OPTIONS
        --[no-]delete     - Delete the original file after its been imported into the target service. (default: enabled)
        --ocr             - OCR the document if it is a PDF
        --[no-]proc_rules - Process the file through the rules. (default: enabled)
        --prompt          - Open a prompt to rename the file before its processed through the rules.

By default, the original document will be removed after the new note has been created. If you do not want this behavior, you can use the `--no-delete` option. 

If you want to skip the rules processing all together, you can use the `--no-proc_rules` option. 

The `--prompt` option can be very useful if you have rules that are scoped with the filename. This will open a prompt and allow you to rename the file. Maybe you can add a word or two to ensure some rules get triggered. 

The `--ocr` setting will run the document through the configured OCR engine if the document is a PDF file. 


#### assign

Assign tags to a note. This command has not been implemented yet. 

#### unassign

Remove tags from a note. This command has not been implemented yet. 

#### search

Search for notes. This command has not been implemented yet. 
 
#### initconfig

The `initconfig` command will automatically seed a new `.paperless.rc` config file with all of the default values. It will not create any rules though. You will have to create those on your own. 

    NAME
        initconfig - Initialize the config file using current global options

    SYNOPSIS
        paperless [global options] initconfig [command options]

    DESCRIPTION
        Initializes a configuration file where you can set default options for command line flags, both globally and on a per-command basis. These
        defaults override the built-in defaults and allow you to omit commonly-used command line flags when invoking this program

    COMMAND OPTIONS
        --[no-]force - force overwrite of existing config file

#### editconfig

Since the `.paperless.rc` file will be hidden from Finder, it can be a challenge for some people to figure out how to edit it. Use this command to open the file inside TextEdit. 


#### help

    NAME
        help - Shows a list of commands or help for one command

    SYNOPSIS
        paperless [global options] help [command options] command

    DESCRIPTION
        Gets help for the application or its commands. Can also list the commands in a way helpful to creating a bash-style completion function

    COMMAND OPTIONS
        -c - List commands one per line, to assist with shell completion

### Global Options

Its recommended that all the global settings be set inside the `.paperless.rc` file. However, it could be useful to override the settings in the config file via the following global command line options. For an explanation of each setting, you will need to refer to the **Configuration File** section below.

The following options would be used most via command line. 

`--simulate` provides you a nice way to test your rules from the command line and verify that documents will end up where you would like. 

`--rules_file` allows you to define a separate rules file than the rules inside the config file. This could be useful if you want to keep multiple sets of rules. Simple set this to the path of the new rules file. 


    GLOBAL OPTIONS
        --date_default=Date Default - If the date cannot be discovered within the document contents, then use "filedate" or "today" as the default.
                                      (default: filedate)
        --date_format=Date Format   - The default format for the date when inserted using <date> variable. (default: %Y-%m-%d)
        --date_locale=Date Locale   - The locale format of the date: "us" or "euro" (default: us)
        --destination=Notebook      - Default destination to add notes into (default: @Inbox)
        --help                      - Show this message
        --ocr_engine=OCR App        - The name of the app to OCR pdf documents (pdfpen|pdfpenpro|none) (default: pdfpenpro)
        --rules_file=Rules file     - The path to a new rules file. If not defined, the global rules from the config file will be used. (default:
                                      none)
        --service=Services          - The application where the document will be added to. (default: evernote)
        --simulate                  - Only print what would be done. Nothing actually gets modified.
        --text_ext=Text extensions  - A list of file extensions that will be treated as text when added to services like Evernote. (default: txt md
                                      mmd)
        --version                   -


## Configuration File `.paperless.rc` 

Instead of passing a ton of options via command line, you can setup the configuration values in a file named `.paperless.rc`. This file should live in your home directory.

### How to create the config file

There is a command that automatically creates the `.paperless.rc` configuration file for you. It will also seed the settings in the file with the default global setting for each option. Run the following command to get this done. 

    $ paperless initconfig

**NOTE**: This process will not create any rules for you. Read on for information about creating your own rules. 

### How to edit your config file

Since the `.paperless.rc` file will be hidden from Finder, it can be a challenge for some people to figure out how to edit it. There is a convenient built in command that will open the file inside TextEdit for you. 

    $ paperless editconfig

### Sample Configuration File

Here is a sample file to get you going. For information about the rules, check out the Rules section. 

    ---
    :ocr_engine: pdfpenpro
    :date_locale: us
    :date_format: '%Y-%m-%d'
    :date_default: filedate
    :destination: '@Inbox'
    :text_ext: txt md mmd
    :simulate: false
    :service: evernote
    :rules:
     - 
       description: Date Rule
       scope: content
       condition: <date>
     - 
       description: Find my name anywhere and tag me
       scope: content filename
       condition: Joe\s*Workman
       tags: geek 'joe workman'
     - 
       description: Find American Funds and do things to it
       scope: content 
       condition: American Funds
       tags: retirement
       destination: /Volumes/MacRAID/Documents/Personal.dtBase2::/Retirement
       service: devonthinkpro
       title: '<match> Statement <date=%Y-%m>'


### Configuration Options

* **date_default**

    If a date cannot be discovered within the document contents,   then the date of the notes will default to either one of the following values. 

    * `filedate` The last modification date of the file. 
    * `today` Today's date.


* **date_format**

    The default format for the date when inserted using `<date>` configuration variable (more on this in the Rules section). The format follows the [standard strftime formats](http://www.ruby-doc.org/core-1.9.3/Time.html#method-i-strftime).

    Default: `%Y-%m-%d` (2013-03-28)


* **date_locale**

    This defines the locale format for the date string. This is used  when analyzing the document for the date. Is the date format *backasswords* like in the U.S. (12/29/2012) or normal like the rest of the world (29/12/2012). 

    * `us` if you are looking for U.S. format.
    * `euro` if you are looking for the logical format. 

* **service**

    The application where the document will be added to. The following services are currently available. 

    * `finder` Save your documents on the OS X file system. 
    * `evernote` [Evernote](http://evernote.com) is a great online service.
    * `devonthinkpro` [DevonThink Pro](http://www.devontechnologies.com/products/devonthink/overview.html) has been a staple in the Mac community for years. 
 

* **destination**

    Default destination to add your documents into. The value of this will vary based on the service that you are using. 

    * **Finder** - The full path to the folder where you want the document to be stored. 
        * Example: `:destination: /Volumes/users/username/Documents/Archive`
    * **Evernote** - The name of the notebook that you want to store the note into. 
        * Example: `:destination: Inbox`
    * **DevonThink Pro** - This option is a bit more complicate because you need to define both the path to the database and the path to the folder. `<database>::<folder>` 
        * Example: `:destination: /Volumes/users/username/Documents/Database.dtBase2::/Archive/Folder`

* **ocr_engine**

    Paperless can leverage several applications in order to OCR your document. The OCR process will only get kicked off for PDF documents. 

    * `none` Disable OCR (default)
    * `pdfpen` [PDFPen](http://jwurl.net/Wv3MTi) is an awesome app from Smile Software. 
    * `pdfpenpro` [PDFPenPro](http://jwurl.net/XQpCOt) is their pro version. 
    * `devonthinkpro` [DevonThink Pro](http://www.devontechnologies.com/products/devonthink/overview.html) has been a staple in the Mac community for years. 


* **text_ext**

    For non-file based services like Evernote, it can sometimes add non-common text based files as attachments instead of inserting the actual text of the document into the note. This setting defines a list of file extensions that you want to make certain get treated as text. 

    Default: `txt md mmd`


## Rules

As you see from the sample configuration file above, you can define multiple rules. Each rule must follow a certain format so that it will be properly parsed. 

    :rules:
     - 
       description: Rule #1
       scope: content 
       condition: My Condition
       tags: tag1 tag2
       destination: Inbox
       service: evernote
       title: '<match> Statement <date=%Y-%m>'

* Begin the rules definition with the `:rules:` declaration. 
* Each new rule after much start the a ` - `.
* Then you simply list out all of the rule fields. The only required fields for a rule are `description` , `scope` and `condition`

You do not need to define a particular field if it does not pertain to that rule. You can also leave the value for a field blank and it is essentially the same as omitting it for the rule. 

### How the rules are processed

The rules are processed in the order that they are defined. When a rule is matched and applies a value to a particular field, the field becomes locked. No other rule can now apply changes to field. 

Tags are an exception. Since you can have as many tags as you want on a document, if multiple rules match a document, the tags from each rule will be applied to the document. 

Lets look at a simple example. 

    :rules:
     - 
       description: Rule #1 - BofA Statements
       scope: content 
       condition: Bank of America
       tags: bank financial
       destination: 'Bank Statements'
       title: 'BofA Statement <date=%Y-%m>'
     - 
       description: Rule #2 - Joe Stuff
       scope: content 
       condition: Joe Workman
       tags: joe
       destination: Personal

Let's say that I have just scanned in my last bank statement and it matches both of the rules defined above. The tags defined from both rules will be applied. The destination from Rule #1 will win. The title from Rule #1 will be applied as well (more on the cool `<date>` variable later. If a title had been set in Rule #2, it still would not have gotten applied though. This is what the final outcome will be. 

    tags: bank financial joe
    destination: 'Bank Statements'
    title: 'BofA Statement <date=%Y-%m>'

### Rule Fields

Here is an overview of each of the available fields for a rule. 

**Note**: One precaution is that if you want to use special characters such as ` @ ` , ` % ` or spaces, you will need to surround that text in quotes.

* **description**:

    This field is solely used for future you… so that you remember what a particular rule is used for.

* **scope**:

    This defines the scope that the condition will be evaluated against. The following scopes are supported. A rule can have multiple values for scope defined. Ex: `scope: content filename`

    * `filename` The condition will be evaluated against the name of the file, excluding the extension. 
    * `content` The condition will be evaluated against the contents of the document. 

    Use the `--prompt` option to manually manipulate the filename via a dialog box before it gets processed through the rules. 

    If the document is a PDF, you will need to ensure that it has gone through OCR.

* **condition**:

    This is the text that you would like to match upon for your rule. Conditions fully supports [regular expressions](http://www.ruby-doc.org/core-1.9.3/Regexp.html). This allows you to get pretty clever with your matches. However, all conditions are set to be case insensitive. You can then referenced the matched text with the `<match>` special variable within other rule fields. 

    *Testing your Regex*: [Patterns](http://jwurl.net/WTCYfZ) and [Rubular](http://rubular.com) are both nice tools for testing your regular expressions. I use Patterns daily!

* **tags**:

    This is a space delimited list of tags that will be added document. For file based services like Finder and DevonThink, *openmeta* tags will be applied to the file. Evernote's tag system will be used for those notes. 

* **title**:

    This is the title of the note. For file based services like Finder and DevonThink, this will be the new name of the file. For Evernote, it will be the title of the note. 

* **destination**:

   This will override the global destination setting described in the Global Options section. All the same standards from the global setting applies here as well. 

* **service**:

   This will override the global service setting described in the Global Options section. All the same options from the global setting applies here as well. 


### Special Rule - Search content for date string

There is a special rule that kicks off the analyzing of a document for the first instance of a date. This rule can be anywhere in the rules list, however, I recommend you just add it to the top if you want this feature. 

     - 
       description: Date Rule
       scope: content
       condition: <date>

If this rule is not apart of the rule set, then default_date setting will be used instead.

The following basic date formats (and many derivatives of them) are searched for. The first string that matches will be used as the date. 

* December 29, 2012
* 29 December 2012
* 12/29/2012

### Rule Variables

#### match

Where used, the `<match>` variable will be replaced the entire string that the condition matched. This can be utilized with any of the supported rule fields: `destination` , `title` , `service` and `tags`

#### date

Where used, the `<date>` variable will be replaced the discovered date. If a date was not found inside the document, then the `date_default` setting will be used. The format for this date is configured in the `date_format`.

You can override the the default format by adding it within the date variable like `<date=%Y-%m>`. In this example the date format will be set to **%Y-%m** instead of what is set in the date_default setting. 


#### nomove

When you are using the Finder service, you can set the destination to `<nomove>` this will keep the file in the folder that it is already in. However, based on the rules, the file name be renamed. 


## Examples

Simulate the creation of a new note:

	$ paperless --simulate create document.pdf

OCR and prompt for renaming the file: 

	$ paperless create --ocr --prompt document.pdf 

Define a separate rules file and OCR:

	$ paperless --rules_file=/MacHD/rules.txt create --ocr document.pdf


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thank You

paperless uses the following awesome libraries:

* GLI (gem) - <https://github.com/davetron5000/gli>
* rb-appscript (gem) - <http://appscript.sourceforge.net>
* pdf-reader (gem) - <https://github.com/yob/pdf-reader>
* markdown (gem) - <https://github.com/geraldb/markdown>
* openmeta - <http://code.google.com/p/openmeta>
* CocoaDialog.app - <http://mstratman.github.com/cocoadialog>