# OpenAI Chat API Workflow for Alfred

<img src='./icons/openai.png' style='height:120px;'/>

🎩 [Alfred 5](https://www.alfredapp.com/) Workflow for using [OpenAI](https://beta.openai.com/) Chat API to interact with GPT-3.5/GPT-4 🤖 It also allows image generation using DALL-E API 🖼️ and speech-to-text conversion using Whisper API 🎤

<img src='./docs/img/OpenAI-Alfred-Workflow.png' style='width:600px;'/>

<kbd><img src='./docs/img/chat.png' style='width:800px;'/></kbd>

## Downloads

**Current version**: **2.0.2**

[**Download Workflow**](https://github.com/yohasebe/openai-chat-api-workflow/raw/main/openai-chat-api.alfredworkflow)

**Recent Change Log**

- **2.0.2: Support for interactive chat 💬 with GPT ❗️**
- 1.12.0: Popup model selector is introduced
- 1.11.3: Speech-to-text file action issue fixed
- 1.11.2: New keyword (`gpt`) added for simple query
- 1.11.0: Speech-to-text using Whisper API added
- 1.10.2: `Enhance Prompt` supports both `gpt-4` and `gpt-3.5-turbo`.
- 1.10.0: `Enhance Prompt` option for image generation mode added
- 1.9.1: 1024x1024 image generation issue fixed
- 1.9.0: Image generation using DALL·E API supported

[Complete Change Log](https://github.com/yohasebe/openai-chat-api-workflow/blob/main/CHANGELOG.md)

## Dependencies

- Alfred 5 [Powerpack](https://www.alfredapp.com/shop/)
- OpenAI [API key](https://platform.openai.com/account/api-keys)
- [Pandoc](https://pandoc.org/): Needed to convert Markdown to HTML
- [Sox](https://sox.sourceforge.net/sox.html): Needed for audio recording
- [jq](https://jqlang.github.io/jq/): Needed to handle chat history in JSON
- [duti](https://github.com/moretension/duti): Needed to use Google Chrome to open chat window (optional)

To start using this workflow, you must set the environment variable `apikey`, which you can get by creating a new [OpenAI account](https://platform.openai.com/account/api-keys). See also the [Configuration](#configuration) section below.

You will also need to install the `pandoc` and `sox` programs. Pandoc will allow this workflow to convert the Markdown response from OpenAI to HTML and display the result in your default web browser with syntax highlighting enabled (especially useful when using this workflow to generate program code). Sox will allow you to record voice audio to convert to text using Whisper speech-to-text API.

Installing Pandoc and Sox will be just a few clicks once this workflow has been included in the [Alfred Gallery](https://alfred.app/). For now, install these programs using [homebrew](https://brew.sh/). Once homebrew is installed, run the following command.

```shell
  brew install pandoc sox jq duti
```

## ⚡️ Simple Direct Query/Chat

If you simply want to ask something with GPT in a chat:

- Method 1: Type keyword `gpt` → space/tab → input query text (e.g. "**gpt** what is a large language model?")
- Method 2: set up a custom hotkey to `OpenAI Direct Query`

<img src='./docs/img/direct-query.png' style='width:450px;'/>

## ⚙️ Other Ways to Execute a Query

### ⌨️ Using Alfred Textbox

You can enter a query text directly into Alfred textbox:

- Method 1: Alfred textbox → keyword (`openai`) → space/tab → input query text → select a command (see below)
- Method 2: Alfred textbox → input query text → select fallback search (`OpenAI Query`)

### 📋 Using Selected Text

You can select any text on your Mac and send it to the workflow:

- Method 1: select text → universal action hotkey → select `OpenAI Query`
- Method 2: set up a custom hotkey to `Send selected text to OpenAI`

### 🌐 Using Text Box in Safari or Google Chrome

You can open a web interface

- Method 1: Alfred textbox → keyword (`openai-textbox`)
- Method 2: set up a custom hotkey to `Open web interface`

** Using Google Chrome**

If your default browser is Google Chrome and "duti" command is installed to the system, the web interface will be opened by Google Chrome. Otherwise, Safari will be used.

<kbd><img width="800" alt="SCR-20221207-st2" src="./docs/img/web-interface.png"></kbd>

## Basic Commands

The input text is used as a prompt to the OpenAI Chat API. The original input text can be prepended or postfixed with instructional text to compose a complex query to be given to the API.

#### <span><img src='./icons/patch-question.png' style='height:2em;'/></span> Direct Query

The input text is directly sent as a prompt to the OpenAI Chat API.

<kbd><img src='./docs/img/direct-query.gif' style='width:600px;'/></kbd>

#### <span><img src='./icons/arrow-bar-down.png' style='height:2em;'/></span> Prepend Text + Query

After the initial text is entered, the user is prompted for additional text. The additional text is added *before* the initial text, and the resulting text is used as the query.

<kbd><img src='./docs/img/prepend.gif' style='width:600px;'/></kbd>

#### <span><img src='./icons/arrow-bar-up.png' style='height:2em;'/></span> Append Text + Query

After the initial text is entered, the user is prompted for additional text. The additional text is added *after* the initial text and the resulting text is used as the query.

#### <span><img src='./icons/picture.png' style='height:2em;'/></span> Generate Image

The DALL-E API is used to generate images according to the prompts entered. In general, the more detailed the prompt, the closer the content and quality of the output image will be to what is desired. 

> Rugby players are playing in a match using a huge watermelon as a ball

<kbd><img width="600" src="./docs/img/image-examples.png"></kbd>

When the `Enhance Prompt` option is enabled, a short prompt, for example the following, is expanded by GPT into more detailed text, which is then used to generate images.

> View of downtown Austin from across the river

<kbd><img width="600" src="./docs/img/prompt-enhancement.png"></kbd>

#### <span><img src='./icons/code-square.png' style='height:2em;'/></span> Write Program Code

GPT will generate program code and example output according to the text entered. Specify the purpose of the program, its function, the language and technology to be used, etc.

**Example Input**

> Create a command line program that takes an English sentence and returns syntactically parsed output. Provide program code in Python and example usage.

**Example Output**

<kbd><img width="800" src="./docs/img/code.png"></kbd>

## More Specific Commands

These are features mainly based on OpenAI's example usage of its Chat API. The user-specified values to the following user settings are ignored when running these commands:

- `temperature`
- `frequency_penalty`
- `presence_penalty`

### Language-related

#### <span><img src='./icons/quora.png' style='height:2em;'/></span> Ask in Your Language 

You can ask questions in the language set to the variable `first_language`. 

**Note**: If the value of `first_language` is not `English` (e.g. `Japanese`), the query may result in a more or less inaccurate response.

#### <span><img src='./icons/translate.png' style='height:2em;'/></span> Translate L1 to L2 

Translate text in the language specified in the variable `first_language` to the language specified in the `second_language`.

#### <span><img src='./icons/translate.png' style='height:2em;'/></span> Translate L2 to L1 

Translate text in the language specified in the variable `second_language` to the language specified in the variable `first_language`.

#### <span><img src='./icons/pencil.png' style='height:2em;'/></span> Grammar Correction

Correct sentences into standard English. See OpenAI's [description](https://beta.openai.com/examples/default-grammar).

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

Translates complex text into more straightforward concepts. See OpenAI's [description](https://beta.openai.com/examples/default-summarize) for this example.

#### <span><img src='./icons/key.png' style='height:2em;'/></span> Keywords

Extract keywords from a block of text. See OpenAI's [description](https://beta.openai.com/examples/default-keywords) for this example.

## Speech to Text

The Whisper API can convert speech into text in a variety of languages. Please refer to the [Whisper API FAQ](https://help.openai.com/en/articles/7031512-whisper-api-faq) for available languages and other limitations.

### Audio File to Text

You can select an audio file in `mp3`, `mp4`, `flac`, `webm`, `wav`, or `m4a` format (under 25MB) and send it to the workflow:

Select the file → universal actioin hotkey select → `OpenAI Speech-to-Text`

### Record Voice Audio and Transcribe

Alternatively you can record voice audio and send it to the Workflow for transcription using the Whisper API. The recording must be no longer than 30 minutes and will automatically stop after this time. Recording time is limited to 30 minutes and stops automatically after this limit.

<kbd><img width="600" alt="transcript-srt" src="./docs/img/speech-to-text.png"></kbd>

- Alfred textbox → keyword (`openai-speech`) → Terminal window opens and recording starts
- Speak to internal or external microphone → Press Enter to finish recording
- Choose processes to apply to the recorded audio

  - transcribe (+ delete recording)
  - transcribe (+ save recording to desktop)
  - transcribe and query (+ delete recording)
  - transcribe and query (+ save recording to desktop)
  - exit (+ delete recording)
  - exit (+ save recording to desktop)

You can choose the format of the transribed text from `text`, `srt` or `vtt` in the workflow's settings. Below are examples in the `text` and `srt` formats:

<kbd><img width="700" alt="transcript-srt" src="./docs/img/transcript-text.png"></kbd>

<kbd><img width="700" alt="transcript-srt" src="./docs/img/transcript-srt.png"></kbd>

## Check API Usage

You can check how many tokens you have used in the current billing period on OpenAI Usage Page--type in the keyword `openai-usage`. See also OpenAI's [Billing](https://platform.openai.com/account/billing/overview) page.

## Configuration 

### Required Settings

- **OpenAI API Key**: Set your secret API key for OpenAI. Sign up for OpenAI and get your API key at [https://platform.openai.com/account/api-keys/](https://platform.openai.com/account/api-keys).
- **Model**: OpenAI's chat [model](https://beta.openai.com/docs/api-reference/models) used for the workflow. (default: `gpt-3.5-turbo`)
- **Base URL**: The base URL of the OpenAI Chat API. (default: `https://api.openai.com/v1`)

### Chat Parameters

- **Max Tokens**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-max_tokens). (default: `2048`)
- **Temperature**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-temperature). (default: `0.3`)
- **Top P**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-top_p). (default: `1.0`)
- **Frequency Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-frequency_penalty). (default: `0.0`)
- **Presence Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-presence_penalty). (default: `0.0`)

- **Memory Span**: Set the number of past utterances sent to the API as a context. Setting 4 to this parameter means 2  conversation turns (user + assistant) will be sent as a context for a new query. The larger the value, more tokens will be consumed. (default: `4`)
- **System Content**: Text to sent with every query sent to API as a general information about the specification of the chat. The default value is as follows:

>You are a friendly but professional consultant who answers various questions, write computer program code, make decent suggestions, give helpful advice in response to a prompt from the user. Your response must be consise, suggestive, and accurate. 

### Image Generation Parameters

- **Number of Images**: Set the number of images to generate in image generation mode from `1` to `10`. (default: `1`)
- **Image Size**: Set the size of images to generate from `256x256`, `512x512`, `1024x1024`. (default: `512x512`)
- **Enhance Prompt**: When enabled, the prompt to the image generation API is automatically enhanced using a GPT-4 model specified in the configuration. This variable is only enabled when the `model` is set to one of the "gpt-4" series. 

### Speech-to-Text Parameters

- **Transcription Format**: Set the format of the text transcribed from the microphone input or audio files from `text`, `srt`, or `vtt`. (default: `text`)
- **Processes after Recording** Set the default choice of what processes follow after audio recording finishes (default: `transcribe [+ delete recording]`).
 
  - Transcribe [+ delete recording]
  - Transcribe [+ save recording to desktop]
  - Transcribe and query [+ delete recording]
  - Transcribe and query [+ save recording desktop]

- **Audio to English**: When enabled, Whisper API will transcribe the input audio and output text translated into English. (default: `disabled`)

### Optional Settings

- **Your First Language**: Set your first language. This language is used when using GPT for translation. (default: `English`)
- **Your Second Language**: Set your second language. This language is used when using GPT for translation.(default: `Japanese`)
- **Max Characters**: Maximum number of characters that can be included in a query (default: `10000`).
- **Timeout**: Number of seconds before the timeout (default: `180`).
- **"Please Wait" Message**: If disabled, the "Please Wait" message is suppressed. (default: `enabled`)
- **Sound**: If checked, a notification sound will play when the response is returned. (default: `disabled`)
- **Echo**: If enabled, the original prompt is contained in the result text. (default: `enabled`)
- **Save File Path**: If set, the results will be saved in the specified path as a markdown file. (default: `not set`)
- **Text to Speech**: If enabled, the results will be read aloud using the system's default text-to-speech language and voice. (default: `disabled`)
- **Output HTML Using Pandoc**: Show results in the default web browser if pandoc is installed. If unchecked (or Pandoc is not installed), Alfred's "Large Type" feature is used to display the result. (default: `enabled`)
- **Custom CSS**: You can specify CSS for the query results HTML. (default: `not set`)

#### Text to Speech

If the `Text to Speech` option is enabled, the result text will be read aloud in the system's standard language and voice. To change the language and speech, go to [Accessibility] - [Vision] -[Spoken Content] in the Mac Settings panel.

<kbd><img width="600" alt="spoken-content-panel" src="https://user-images.githubusercontent.com/18207/221521819-a942e6ba-0523-4526-93da-52b6167defaf.png"></kbd>

#### Custom CSS

You can define the CSS for the HTML that will be displayed as a result of the query. For example, you can freely change the maximum text width, font size and type, background color, etc.

<kbd><img width="500" alt="2023-05-13_20-53-34" src="./docs/img/css.png"></kbd>

## Author

Yoichiro Hasebe (<yohasebe@gmail.com>)

## License

The MIT License

## Disclaimer

The author of this software takes no responsibility for any damage that may result from using it. 
