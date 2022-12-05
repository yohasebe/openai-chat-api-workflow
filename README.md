# OpenAI Text-Completion Workflow for Alfred

<img src='./icons/openai.png' style='height:150px;'/>

An [Alfred workflow](https://www.alfredapp.com/workflows/) to help use [OpenAI](https://beta.openai.com/) GPT-3 text-completion API.

## Downloads

**Current version**: **1.3.0**

[Download workflow](https://github.com/yohasebe/openai-text-completion-workflow/raw/main/openai-text-completion-workflow.alfredworkflow)

**Change Log**

- 1.3.0: `pandoc` option has been added
- 1.2.0: check-for-update command has been added
- 1.1.3: Include original prompt in the response
- 1.1.1: `text-davinci-003` model added and made default 
- 1.1.0: "Ask in Your Language" feature added
- 1.0.0: Initial release

## Requirements

- Alfred 5 [Powerpack](https://www.alfredapp.com/shop/)
- OpenAI [API key](https://openai.com/api/)
- [Pandoc](https://pandoc.org/) command (optional)

## Setting Up

To start using this workflow, you must set the environment variable `apikey`, which you can get by creating an [OpeAI account](https://openai.com/api/). See also [Configuration](#configuration) section below.

It is strongly **recommended** that you install the `pandoc` command and set its path to the `Path to pandoc` setting. This will allow this workflow to convert the Markdown response from OpenAI to HTML and display the result in your default web browser with syntax highlighting enabled (especially usefull when using this workflow to generate program code).

Installation using [homebrew](https://brew.sh/):

```shell
  brew install pandoc
```

You can check paths to `pandoc` aas follows once it has been installed:

```shell
> which pandoc
# When installing on Apple Sillicon Model with homebrew 
#/opt/homebrew/bin/pandoc
# When installing on Intel Model with homebrew 
#/usr/local/bin/pandoc
```

Then set the path in the `path to Pandoc` setting.

## Check for Update

Type `check-for-update` and run the workflow. If there is a newer version, click on the "Download" button. The readme/download page on Github will open.

## How to Execute This Workflow

**Using Selected Text**

- Universal action (**OpenAI Query**)
- Hotkey

**Using Alfred Text Box**

- Keyword (`openai`)
- Fallback search (**OpenAI Query**)

## General Query

The input text is used as a query to OpenAI text-completion API. The original input text can be prepended or postfixed with instructional text to compose a complex query to be given to the API.

#### <span><img src='./icons/patch-question.png' style='height:2em;'/></span> Direct Query

Input text string is directly input as a query to OpenAI text-completion API.

<img src='https://user-images.githubusercontent.com/18207/199722607-e7d0dd82-30ec-482a-b9d6-5609561fc359.gif' style='width:700px;'/>

#### <span><img src='./icons/arrow-bar-down.png' style='height:2em;'/></span> Prepend Text + Query

After the initial text is entered, the user is prompted for additional text. The additional text is added *before* the initial text and the resulting text is used as the query.

<img src='https://user-images.githubusercontent.com/18207/200111874-d90e17a0-3b82-4edd-a3c5-e58c61e35377.gif' style='width:700px;'/>

#### <span><img src='./icons/arrow-bar-up.png' style='height:2em;'/></span> Append Text + Query

After the initial text is entered, the user is prompted for additional text. The additional text is added *after* the initial text and the resulting text is used as the query.

### Program Code Genaration/Completion

#### <span><img src='./icons/quora.png' style='height:2em;'/></span> Ask in Your Language 

GPT-3 will generate program code and example output according to the text entered. Specify the purpose of the program, its function, the language and technology to be used, etc.

**Note**:It is strongly recommended that you install the `pandoc` command and set its path to the `Path to pandoc` setting. This will allow this workflow to convert the Markdown response from OpenAI to HTML and display the result in your default web browser with syntax highlighting enabled. 

## More Specific Commands

These are features mainly based on OpenAI's example usages of its text-completion API. The user-specified values to the following environmental variables are ignored when runing these commands:

- `frequency_penalty` 
- `presence_penalty`  
- `temperature`       
- `top_p`             

### Langauage-related

#### <span><img src='./icons/quora.png' style='height:2em;'/></span> Ask in Your Language 

You can ask questions in the language set to the variable `first_language`. 

**Note**: If the value of `first_language` is not `English` (e.g. `Japanese`), the query may result in a more or less inaccurate response.

#### <span><img src='./icons/translate.png' style='height:2em;'/></span> Translate L1 to L2 

Translate text in the language specified in the variable `first_language` to the language specified in the variable `second_language`.

#### <span><img src='./icons/translate.png' style='height:2em;'/></span> Translate L2 to L1 

Translate text in the language specified in the variable `second_language` to the language specified in the variable `first_language`.

#### <span><img src='./icons/pencil.png' style='height:2em;'/></span> Grammar Correction

Corrects sentences into standard English. See OpenAI's [description](https://beta.openai.com/examples/default-grammar).

### Idea-related

#### <span><img src='./icons/lightbulb.png' style='height:2em;'/></span> Brainstorm

Brainstorm some ideas about a given text.

#### <span><img src='./icons/book.png' style='height:2em;'/></span> Create Study Notes

Provide a topic and get study notes. See OpenAI's [description](https://beta.openai.com/examples/default-study-notes) for this example.

#### <span><img src='./icons/arrow-left-right.png' style='height:2em;'/></span> Analogy Maker 

Create analogies. See OpenAI's [description](https://beta.openai.com/examples/default-analogy-maker) for this example.

#### <span><img src='./icons/list-ul.png' style='height:2em;'/></span> Essay Outline 

Generate an outline for a research topic. See OpenAI's [description](https://beta.openai.com/examples/default-essay-outline) for this example.

### Summarization-related

#### <span><img src='./icons/chat-left-quote.png' style='height:2em;'/></span> TL;DR Summarization 

Summarize text by adding a 'tl;dr:' to the end of a text passage. See OpenAI's [description](https://beta.openai.com/examples/default-tldr-summary) for this example.

#### <span><img src='./icons/emoji-smile.png' style='height:2em;'/></span> Summarize for a 2nd Grader 

Translates difficult text into simpler concepts. See OpenAI's [description](https://beta.openai.com/examples/default-summarize) for this example.

#### <span><img src='./icons/key.png' style='height:2em;'/></span> Keywords

Extract keywords from a block of text. At a lower temperature it picks keywords from the text. See OpenAI's [description](https://beta.openai.com/examples/default-keywords) for this example.

## Check API Usage

You can check how many tokens you have used so far in the current billing period on OpenAI Usage Page. Type in the keyword `openai-usage`. See also OpenAI's [Pricing](https://openai.com/api/pricing/) page.

## Configuration

### Environment Variables

| Variable            | Explanation                                                         | Default Value      |
| -                   | ---                                                                 | -                  |
| `apikey` (required) | Your secret API key for OpenAI                                      |                    |
| `first_language`    | The primary language (usually your native language)                 | `English`          |
| `second_language`   | The secondary language (usually the source language of translation) | `Japanese`         |
| `model`             | The model which will generate the completion                        | `text-davinci-003` |
| `pandoc`            | Path to `pandoc` command                                            |                    |
| `sound`             | Play sound when result is ready                                     | `true`             |
| `speak`             | Read aloud the result text using "say" command of MacOS             | `false`            |
| `max_characters`    | Maximum number of characters that can be included in a query        | `10000`            |
| `max_tokens`        | See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-max_tokens)        | `2048`             |
| `frequency_penalty` | See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-frequency_penalty) | `0`                |
| `temperature`       | See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-temperature)       | `0.3`              |
| `top_p`             | See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-top_p)             | `1.0`              |
| `presence_penalty`  | See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-presence_penalty)  | `0`                |

## Author

Yoichiro Hasebe (<yohasebe@gmail.com>)

## License

The MIT License

## Disclaimer

The author of this software takes no responsibility for any damage that may result from using it. 
