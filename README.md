# OpenAI Chat API Workflow for Alfred

<img src='./icons/openai.png' style='height:120px;'/>

🎩 An [Alfred 5](https://www.alfredapp.com/) Workflow for using [OpenAI](https://beta.openai.com/) Chat API to interact with GPT-4 🤖💬 It also allows image generation 🖼️, image understanding 👀, speech-to-text conversion 🎤, and text-to-speech synthesis 🔈

📦 Download [**OpenAI Chat API Workflow**](https://github.com/yohasebe/openai-chat-api-workflow/raw/main/openai-chat-api.alfredworkflow) (version `3.0.1`)

You can execute all the above features using:

- Alfred UI 🖥️
- Selected text 📝
- A dedicated web UI 🌐

The web UI is constructed by the workflow and runs locally on your Mac 💻 The API call is made directly between the workflow and OpenAI, ensuring your chat messages are not shared online with anyone other than OpenAI 🔒 Furthermore, OpenAI does not use the data from the API Platform for training 🚫

You can export the chat data to a simple JSON format external file 📄, and it is possible to continue the chat by importing it later 🔄

<img src="./docs/img/OpenAI-Alfred-Workflow.png" width="600" />

<kbd><img src="./docs/img/openai-chat-api-workflow.gif" width="600" /></kbd>

<kbd><img src="./docs/img/web-interface.png" width="600"></kbd>

<kbd><img src="./docs/img/code-snippets.png" width="600"></kbd>

<kbd><img src="./docs/img/openai-workflow-vision.gif" width="600"></kbd>

## Installation

1. Install [Homebrew](https://brew.sh/)
2. Run the following command in a terminal: `brew install pandoc mpv sox jq duti`
3. Download and run [**OpenAI Chat API Workflow**](https://github.com/yohasebe/openai-chat-api-workflow/raw/main/openai-chat-api.alfredworkflow) 
4. Set your [OpenAI API key](https://platform.openai.com/account/api-keys)

**Setup Hotkeys**

You can set up hotkeys in the settings screen of the workflow. To set up hotkeys, double-click on the light purple workflow elements.

<kbd><img width="600" src="./docs/img/openai-workflow-overview.png"></kbd>

1. Open Web UI (Recommended)
2. Direct Query
3. Send Selected Text
4. Screen Capture for Image Understanding
5. Speech to Text


<b>Dependencies</b>

- Alfred 5 [Powerpack](https://www.alfredapp.com/shop/)
- OpenAI [API key](https://platform.openai.com/account/api-keys)
- [Pandoc](https://pandoc.org/): to convert Markdown to HTML
- [MPV](https://mpv.io/): to play text-to-speech audio stream
- [Sox](https://sox.sourceforge.net/sox.html): to record voice input
- [jq](https://jqlang.github.io/jq/): to handle chat history in JSON
- [duti](https://github.com/moretension/duti): to detect the default web browser

To start using this workflow, you must set the environment variable `apikey`, which you can get by creating a new [OpenAI account](https://platform.openai.com/account/api-keys). See also the [Configuration](#configuration) section below.

You will also need to install the `pandoc` and `sox` programs. Pandoc will allow this workflow to convert the Markdown response from OpenAI to HTML and display the result in your default web browser with syntax highlighting enabled (especially useful when using this workflow to generate program code). Sox will allow you to record voice audio to convert to text using Whisper speech-to-text API.


To set up dependencies (`pandoc`, `mpv`, `sox`, `jq`, and `duti`), first install [homebrew](https://brew.sh/). and run the following command.

```shell
  brew install pandoc mpv sox jq duti
```

<b>Change Log</b>

Recent Change Log

- 3.1.3: `gpt-4o-2024-08-06` supported; `gpt-3.5` series models unsupported;
- 3.1.2: `gpt-4o-mini` supported;
- 3.0.1: Default for `Memory Span` set to `10`
- 3.0.0: `gpt-4o` supported;

[Complete Change Log](https://github.com/yohasebe/openai-chat-api-workflow/blob/main/CHANGELOG.md)

## Methods of Execution

here are three methods to run the workflow: 1) Using commands within the Alfred UI, 2) Passing selected text to the workflow, 3) Utilizing the Web UI. Additionally, there’s a convenient method for making brief inquiries to GPT

<b>Commands within the Alfred UI</b>

You can enter a query text directly into Alfred textbox:

- Method 1: Alfred textbox → keyword (`openai`) → space/tab → input query text → select a command (see below)
- Method 2: Alfred textbox → input query text → select fallback search (`OpenAI Query`)


<b>Passing Selected Text</b>

You can select any text on your Mac and send it to the workflow:

- Method 1: select text → universal action hotkey → select `OpenAI Query`
- Method 2: set up a custom hotkey to `Send selected text to OpenAI`


<b>Using Web Interface</b>

You can open a web interface

- Method 1: Alfred textbox → keyword (`openai-webui`)
- Method 2: set up a custom hotkey to `Open web interface`

**Using the Default Browser**

If your default browser is set to one of the following and the duti command is installed on your system, the web interface will automatically open in your chosen browser. If not, Safari will be used as the default.

- Google Chrome (Stable, Beta, Dev, etc.)
- Microsoft Edge (Stable, Beta, Dev, etc.)
- Brave Browser

Restart OpenAI Workflow server by executing `openai-restart-server` in case the web UI does not work as expected after changing the default browser.

**Web UI Modes**

Switch modes (`light`/`dark`/`auto`) with `Web UI Mode` selector in the settings.

<kbd><img width="600" src="./docs/img/web-interface-dark.png"></kbd>


<b>Simple Direct Query/Chat</b>

To quickly chat with GPT:

- Method 1: Type keyword `gpt` → space/tab → input query text (e.g. "**gpt** what is a large language model?")
- Method 2: set up a custom hotkey to `OpenAI Direct Query`

<img src='./docs/img/direct-query.png' style='width:700px;'/>

## Basic Commands

With `Direct Query`, the input text is sent directly to the OpenAI Chat API as a prompt. You can also create a query by prepending or appending text to the input text.

<span><img src='./icons/patch-question.png' style='height:1em;'/></span> <b>Direct Query</b>

The input text is directly sent as a prompt to the OpenAI Chat API.

<kbd><img src='./docs/img/direct-query.gif' style='width:700px;'/></kbd>

<span><img src='./icons/arrow-bar-down.png' style='height:1em;'/></span> <b>Prepend Text + Query</b>

After the initial text is entered, the user is prompted for additional text. The additional text is added *before* the initial text, and the resulting text is used as the query.

<kbd><img src='./docs/img/prepend.gif' style='width:700px;'/></kbd>


<span><img src='./icons/arrow-bar-up.png' style='height:1em;'/></span> <b>Append Text + Query</b>

After the initial text is entered, the user is prompted for additional text. The additional text is added *after* the initial text and the resulting text is used as the query.


<span><img src='./icons/picture.png' style='height:1em;'/></span> <b>Generate Image</b>

The DALL-E API (`dall-e-3` or `dall-e-2`) is used to generate images according to the prompts entered. See [Image Generation](#image-generation) below.


## Commands for Specific Purposes

Some of the examples shown on [OpenAI's Examples page](https://platform.openai.com/examples) are incorporated into this Workflow as commands. Functions not prepared as commands can be realized by giving appropriate prompts to the above [Basic Commands](#basic-commands).

<span><img src='./icons/code-square.png' style='height:1em;'/></span> <b>Write Program Code</b>

GPT generates program code and example output according to the text entered. You can specify the purpose of the program, its function, the language and technology to be used, etc.

**Example Input**

> Create a command line program that takes an English sentence and returns syntactically parsed output. Provide program code in Python and example usage.

**Example Output**

<kbd><img width="600" src="./docs/img/code.png"></kbd>


<span><img src='./icons/quora.png' style='height:1em;'/></span> <b>Ask in Your Language</b>

You can ask questions in the language set to the variable `first_language`.

**Note**: If the value of `first_language` is not `English` (e.g. `Japanese`), the query may result in a more or less inaccurate response.


<span><img src='./icons/translate.png' style='height:1em;'/></span> <b>Translate L1 to L2</b>

GPT translates text in the language specified in the variable `first_language` to the language specified in the `second_language`.


<span><img src='./icons/translate.png' style='height:1em;'/></span> <b>Translate L2 to L1</b>

GPT translates text in the language specified in the variable `second_language` to the language specified in the variable `first_language`.


<span><img src='./icons/pencil.png' style='height:1em;'/></span> <b>Grammar Correction</b>

GPT corrects sentences that may contain grammatical errors. See OpenAI's [description](https://beta.openai.com/examples/default-grammar).



<span><img src='./icons/lightbulb.png' style='height:1em;'/></span> <b>Brainstorm</b>

GPT assists you in brainstorming innovative ideas based on any given text.


<span><img src='./icons/book.png' style='height:1em;'/></span> <b>Create Study Notes</b>

GPT provides study notes of a given topic. See OpenAI's [description](https://beta.openai.com/examples/default-study-notes) for this example.


<span><img src='./icons/arrow-left-right.png' style='height:1em;'/></span> <b>Analogy Maker</b>

GPT creates analogies. See OpenAI's [description](https://beta.openai.com/examples/default-analogy-maker) for this example.


<span><span><img src='./icons/list-ul.png' style='height:1em;'/></span> <b>Essay Outline</b>

GPT generates an outline for a research topic. See OpenAI's [description](https://beta.openai.com/examples/default-essay-outline) for this example.


<span><img src='./icons/chat-left-quote.png' style='height:1em;'/></span> <b>TL;DR Summarization</b>

GPT summarizes a given text. See OpenAI's [description](https://beta.openai.com/examples/default-tldr-summary) for this example.


<span><img src='./icons/emoji-smile.png' style='height:1em;'/></span> <b>Summarize for a 2nd Grader</b>

GPT translates complex text into more straightforward concepts. See OpenAI's [description](https://beta.openai.com/examples/default-summarize) for this example.


<span><img src='./icons/key.png' style='height:1em;'/></span> <b>Keywords</b>

GPT extracts keywords from a block of text. See OpenAI's [description](https://beta.openai.com/examples/default-keywords) for this example.


## Image Generation

The image generation can be executed through one of the above commands. It is also possible to use the web UI. By using the web UI, you can interactively change the prompt to get closer to the desired image.

<kbd><img width="600" src="./docs/img/image-generation-1.png"></kbd>

When the image generation mode is set to `dall-e-3`, the user's prompt is automatically expanded to a more detailed and specific prompt. You can also edit the expanded prompt and regenerate the image.

<kbd><img width="600" src="./docs/img/image-generation-2.png"></kbd>

<kbd><img width="600" src="./docs/img/image-generation-3.png"></kbd>


## Image Understanding

The image understanding can be executed through the `openai-vision` command. It starts a capture mode and lets you specify a part of the screen to be analyzed. Alternatively, you can specify an image file (jpg, jpeg, png, gif) using "OpenAI Vision" file action. This mode needs `gpt-4o` or `gpt-4o-mini` model to be set in the workflow settings.

## Speech Synthesis and Speech Recognition

Most text-to-speech and speech-to-text features are available on the web UI. However, there are certain specific features that are provided as commands, such as audio file to text conversion and transcription with timestamps.

<kbd><img width="600" src="./docs/img/speech-to-text-web.png"></kbd>

<b>Text-to-Speech Synthesis</b>

Text entered or response text from GPT can be read out in a natural voice using OpenAI's text-to-speech API.

- Method 1: Press `Play TTS` button on the web UI
- Method 2: select text → universal action hotkey → select `OpenAI Text-to-Speech`


<b>Speech-to-Text Conversion</b>

The Whisper API can convert speech into text in a variety of languages. Please refer to the [Whisper API FAQ](https://help.openai.com/en/articles/7031512-whisper-api-faq) for available languages and other limitations.

- Method 1: Press `Voice Input` button on the web UI
- Method 2: Alfred textbox → keyword (`openai-speech`)


<b>Audio File to Text</b>

You can select an audio file in `mp3`, `mp4`, `flac`, `webm`, `wav`, or `m4a` format (under 25MB) and send it to the workflow:

- Select the file → universal actioin hotkey select → `OpenAI Speech-to-Text`


<b>Record Voice Audio and Transcribe</b>

You can record voice audio and send it to the Workflow for transcription using the Whisper API. The recording must be no longer than 30 minutes and will automatically stop after this time. Recording time is limited to 30 minutes and stops automatically after this limit.

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

<kbd><img width="600" alt="transcript-srt" src="./docs/img/transcript-text.png"></kbd>

<kbd><img width="600" alt="transcript-srt" src="./docs/img/transcript-srt.png"></kbd>



## Other Features

<b>Import/Export</b>

You can export your chat data to a straightforward JSON format file, and resume your conversation later by importing it back in.

To export data, simply click on `Show Entire Chat` in the chat window to navigate to the chat history page, then select `Export Data`. To import data, just hit `Import Data` on either the home page or the chat history page.

<b>Monitor API Usage</b>

To review your token usage for the current billing cycle on the OpenAI Usage Page, type the keyword `openai-usage`. For more details on billing, visit OpenAI's [Billing Overview](https://platform.openai.com/account/billing/overview).

## Configuration Parameters

You can set various parameters in the settings panel of this Workflow. Some of the parameters set here are used as default values but you can make temporary changes to the values on the web UI. You can also access the settings panel by clicking `Open Config` from the web UI.

<b>Required Settings</b>

- **OpenAI API Key**: Set your secret API key for OpenAI. Sign up for OpenAI and get your API key at [https://platform.openai.com/account/api-keys/](https://platform.openai.com/account/api-keys).

- **Base URL**: The base URL of the OpenAI Chat API. (default: `https://api.openai.com/v1`)

<b>Web UI Parameters</b>

- **Loopback Address**: Either `localhost` or `127.0.0.1` can be used as the loopback address of the UI server. If the web UI does not work as expected, try the other. (default: `127.0.0.1`)
- **Stream Output**: Show results in the default web browser. If unchecked, Alfred's "Large Type" feature is used to display the result. (default: `enabled`)
- **Hide Speech Buttons**: When enabled, the buttons for TTS playback and voice input are hidden on the web UI.
- **Web UI Mode**: Set your preferred UI mode (`light`/`dark`/`auto`). (default: `auto`)

<b>Chat Parameters</b>

- **Model**: OpenAI's chat [model](https://beta.openai.com/docs/api-reference/models) used for the workflow (default: `gpt-4o-mini`). If you want to use the latest and greatest model, set it to `gpt-4o-2024-08-06`. Here are some of the models currently available:

  - `gpt-4o-mini`
  - `gpt-4o-2024-08-06`
  - `gpt-4o`

- **Max Tokens**: Maximum number of tokens to be generated upon completion (default: `2048`). If this parameter is set to `0`, `null` is sent to the API as the default value (the maximum number of tokens is not specified). See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-max_tokens).
- **Temperature**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-temperature). (default: `0.3`)
- **Top P**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-top_p). (default: `1.0`)
- **Frequency Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-frequency_penalty). (default: `0.0`)
- **Presence Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-presence_penalty). (default: `0.0`)
- **Memory Span**: Set the number of past utterances sent to the API as a context. Setting `4` to this parameter means 2 conversation turns (user → assistant → user → assistant) will be sent as the context for a new query. The larger the value, more tokens will be consumed. (default: `10`)
- **Max Characters**: Maximum number of characters that can be included in a query (default: `50000`).
- **Timeout**: The number of seconds (default: `10`) to wait before opening the socket and connecting to the API. If the connection fails, reconnection (up to 20 times) will be attempted after 1 second.
- **Add Emoji**: If enabled, the response text from GPT will contain emoji characters appropriate for the content. This is realized by adding the following sentence at the end of the system content. (default: `enabled`)

  > Add emojis that are appropriate to the content of the response.

- **System Content**: Text to sent with every query sent to API as a general information about the specification of the chat. The default value is as follows:

  > You are a friendly but professional consultant who answers various questions, make decent suggestions, and give helpful advice in response to a prompt from the user. Your response must be consise, suggestive, and accurate.


<b>Image Understading Parameters</b>

- **Max Size for Image Understanding**: The maximum pixel value (`512` to `2000`) of the large side of the image data sent to the image understanding API. Larger images will be resized accordingly. (Default: `512`)



<b>Image Generation Parameters</b>

- **Image Generation Model**: `dall-e-3` and `dall-e-2` are available. (default `dall-e-3`)
- **Image Size** (`for dall-e-3`): Set the size of images to generate from `1024x1024`, `1024x1792`, `1792x1024`. (default: `1024x1024`)
- **Quality** (`for dall-e-3`): Choose the quality of image from `standard` and `hd`. (default: `standard`)
- **Style** (`for dall-e-3`): Choose the style of image from `vivid` and `natural`. (default: `vivid`)
- **Number of Images** (for `dall-e-2`) : Set the number of images to generate in image generation mode from `1` to `10`. (default: `1`)
- **Image Size** (for `dall-e-2`): Set the size of images to generate from `256x256`, `512x512`, `1024x1024`. (default: `256x256`)

<b>Text-to-Speech Parameters</b>

- **Text-to-Speech Model**: One of the available TTS models: `tts-1` or `tts-1-hd`. (default: `tts-1`)
- **Text-to-Speech Voice**: The voice to use when generating the audio. Supported voices are: `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`. (default: `alloy`)
- **Text-to-Speech Speed**: The speed of the generated audio. Select a value from 0.25 to 4.0. (default: `1.0`)
- **Automatic Text to Speech**: If enabled, the results will be read aloud using the system's default text-to-speech language and voice. (default: `disabled`)


<b>Speech-to-Text Parameters</b>

- **Transcription Format**: Set the format of the text transcribed from the microphone input or audio files from `text`, `srt`, or `vtt`. (default: `text`)
- **Processes after Recording** Set the default choice of what processes follow after audio recording finishes (default: `transcribe [+ delete recording]`).

  - Transcribe [+ delete recording]
  - Transcribe [+ save recording to desktop]
  - Transcribe and query [+ delete recording]
  - Transcribe and query [+ save recording desktop]

- **Audio to English**: When enabled, Whisper API will transcribe the input audio and output text translated into English. (default: `disabled`)


<b>Other Settings</b>

- **Your First Language**: Set your first language. This language is used when using GPT for translation. (default: `English`)
- **Your Second Language**: Set your second language. This language is used when using GPT for translation.(default: `Japanese`)
- **Sound**: If checked, a notification sound will play when the response is returned. (default: `disabled`)
- **Save File Path**: If set, the results will be saved in the specified path as a markdown file. (default: `not set`)

<b>Environment Variables</b>

Environment variables can be accessed by clicking the `[x]` button located at the top right of the workflow settings screen. Normally, there is no need to change the values of the environment variables.

- `http_keep_alive`: This workflow starts an HTTP server when the web UI is first displayed. After that, if the web UI is not used for the time (in seconds) set by this environment variable, the server will stop. (default: `7200` = 2 hours)
- `http_port`: Specifies the port number for the web UI. (default: `80`)
- `http_server_wait`: Specifies the wait time from when the HTTP server is started until the page is displayed in the browser. (default: `2.5`)
- `websocket_port`: Specifies the port number for websocket communication used to display responses in streaming on the web UI. (default: `8080`)

## Author

Yoichiro Hasebe (<yohasebe@gmail.com>)

## License

The MIT License

## Disclaimer

The author assumes no responsibility for any potential damages arising from the use of this software.
