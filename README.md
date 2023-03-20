# OpenAI Text-Completion Workflow for Alfred

<img src='./icons/openai.png' style='height:120px;'/>

An [Alfred workflow](https://www.alfredapp.com/workflows/) to help use [OpenAI](https://beta.openai.com/) GPT-3 text-completion API and chat API.

<img src='https://raw.githubusercontent.com/yohasebe/openai-text-completion-workflow/main/docs/OpenAI-Alfred-Workflow.png' style='width:700px;'/>

## Downloads

**Current version**: **1.6.7**

[**Download Workflow**](https://github.com/yohasebe/openai-text-completion-workflow/raw/main/openai-text-completion-workflow.alfredworkflow)

**Change Log**

- 1.6.7: Fixed an error that occurred for some users
- 1.6.6: Debug mode added that outputs error messages when problems occur
- 1.6.5: Automatic detection of Pandoc installation
- 1.6.4: Supress "Please Wait" message feature
- 1.6.3: OpenAI Textbox feature updated
- 1.6.0: `GPT-3.5-turbo` model is set to the default
- 1.6.0: ChatGPT API support
- 1.6.0: HTML output option (using Pandoc) is enabled by default
- 1.6.0: check-for-update command removed (in preparation for Alfred Gallery incousion)

[Complete Change Log](https://github.com/yohasebe/openai-text-completion-workflow/blob/main/CHANGELOG.md)

## Requirements

- Alfred 5 [Powerpack](https://www.alfredapp.com/shop/)
- OpenAI [API key](https://openai.com/api/)
- [Pandoc](https://pandoc.org/): See below for installation instructions

## Setting Up

To start using this workflow, you must set the environment variable `apikey`, which you can get by creating an [OpeAI account](https://openai.com/api/). See also [Configuration](#configuration) section below.

You will also need to install the `pandoc` command. This will allow this workflow to convert the Markdown response from OpenAI to HTML and display the result in your default web browser with syntax highlighting enabled (especially usefull when using this workflow to generate program code).

Installing Pandoc will be just a matter of few clicks once this workflow has been included in the [Alfred Gallery](https://alfred.app/). For now, install Pandoc using [homebrew](https://brew.sh/). Once homebrew is installed, run the following command

```shell
  brew install pandoc
```

## How to Execute This Workflow

### Using Selected Text ️📋

Select any text on your Mac and send it to the workflow by:
- Universal Action (`OpenAI Query`) Hotkey
- Custom Hotkey

### Using Alfred Text Box ⌨️

Enter a query text directly to Alfred textbox by:

- Keyword (`openai`)
- Fallback search (`OpenAI Query`)

### Using Textbox in Default Web-browser 🌐

Open a web interface (see the figure below) by

- Keyword (`openai-textbox`)
- Custom Hotkey

<img width="700" alt="SCR-20221207-st2" src="https://user-images.githubusercontent.com/18207/206172474-e4e2f1bd-2c03-4915-8ed0-6a4310127c59.png">

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

#### <span><img src='./icons/code-square.png' style='height:2em;'/></span> Write Program Code

GPT-3 will generate program code and example output according to the text entered. Specify the purpose of the program, its function, the language and technology to be used, etc.

**Example Input**

> Create a command line program that takes an English sentence and returns syntactically parsed output. Provide program code in Python and an example usage.

**Example Output**

<img width="700" alt="SCR-20221205-oby" src="https://user-images.githubusercontent.com/18207/205590260-00f6a698-f0a7-42e8-8ab8-99653a46959f.png">

## More Specific Commands

These are features mainly based on OpenAI's example usages of its text-completion API. The user-specified values to the following environmental variables are ignored when runing these commands:

- `temperature`       
- `frequency_penalty` 
- `presence_penalty`  

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

### Required Settings

- **OpenAI API Key**: Set your secret API key for OpenAI. Sign up for OpenAI and get your API key at [https://openai.com/api/](https://openai.com/api/)
- **Model**: OpenAI's chat/completion [model](https://beta.openai.com/docs/api-reference/models) that generates the completion (dfault: `gpt-3.5-turbo`).

### Text Completion Parameters

- Max Tokens**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-max_tokens) (default: `2048`).
- **Temperature**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-temperature) (default: `0.3`).
- **Top P**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-top_p) (default: `1.0`).
- **Frequency Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-frequency_penalty) (default: `0.0`).
- **Presence Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/completions/create#completions/create-presence_penalty) (default: `0.0`).

### Optional Settings

- **Your First Language**: Set your first language (default: `English`)
- **Your Second Language**: Set your second language (default: `Japanese`). This language is used when using GPT-3 for translation.
- **Max Characters**: Maximum number of characters that can be included in a query (default: `10000`).
- **Timeout**: Number of seconds before timeout (default: 180).
- **"Please Wait" Message**: If disabled, "Please Wait" message is suppressed. (default: `checked`)
- **Sound**: If checked, a notification sound will play when the response is returned.
- **Echo**: If enabled, the original prompt is contained in the result text.
- **Save File Path**: If set, the results will be saved in the specified path as a markdown file
- **Text to Speech**: If enabled, the results will be read aloud using the system default text-to-speech language and voice
- **Output HTML Using Pandoc**: Show results in the default web browser if pandoc is installed.

**Text to Speech**

If the `Text to Speech` option is enabled, the result text will be read out in the system standard language and voice. To change the language and speech, go to [Accessibility] - [Vision] -[Spoken Content] in the Mac Settings panel.

<img width="600" alt="spoken-content-panel" src="https://user-images.githubusercontent.com/18207/221521819-a942e6ba-0523-4526-93da-52b6167defaf.png">

## Author

Yoichiro Hasebe (<yohasebe@gmail.com>)

## License

The MIT License

## Disclaimer

The author of this software takes no responsibility for any damage that may result from using it. 
