# OpenAI Chat API Workflow for Alfred

<img src='./icons/openai.png' style='height:120px;'/>

🎩 An [Alfred 5](https://www.alfredapp.com/) Workflow for using the [OpenAI](https://beta.openai.com/) Chat API to interact with GPT-4 🤖💬. It also allows image generation 🖼️, image understanding 👀, speech-to-text conversion 🎤, and text-to-speech synthesis 🔈.

📦 Download [**OpenAI Chat API Workflow**](https://github.com/yohasebe/openai-chat-api-workflow/raw/main/openai-chat-api.alfredworkflow) (version `3.2.3`)

You can execute all the above features using:

- Alfred UI 🖥️
- Selected text 📝
- A dedicated web UI 🌐

The web UI is constructed by the workflow and runs locally on your Mac 💻. The API call is made directly between the workflow and OpenAI, ensuring your chat messages are not shared online with anyone other than OpenAI 🔒. Furthermore, OpenAI does not use the data from the API Platform for training 🚫.

You can export the chat data to a simple JSON format external file 📄, and it is possible to continue the chat by importing it later 🔄.

<img src="./docs/img/OpenAI-Alfred-Workflow.png" width="600" />

<kbd><img src="./docs/img/openai-chat-api-workflow.gif" width="700" /></kbd>

<kbd><img src="./docs/img/web-interface.png" width="700"></kbd>

<kbd><img src="./docs/img/code-snippets.png" width="700"></kbd>

## Installation

1. Install [Homebrew](https://brew.sh/)
2. Run the following command in a terminal: `brew install pandoc mpv sox jq duti`
3. Download and run [**OpenAI Chat API Workflow**](https://github.com/yohasebe/openai-chat-api-workflow/raw/main/openai-chat-api.alfredworkflow)
4. Set your [OpenAI API key](https://platform.openai.com/account/api-keys)
5. Enable accessibility settings for Alfred in `System Preferences` → `Security & Privacy` → `Privacy` → `Accessibility`

<kbd><img src="./docs/img/accessibility.png" width="600"></kbd>

**Setup Hotkeys**

You can set up hotkeys in the settings screen of the workflow. To set up hotkeys, double-click on the light purple workflow elements.

<kbd><img width="700" src="./docs/img/openai-workflow-overview.png"></kbd>

1. Open Web UI (Recommended)
2. Direct Query
3. Send Selected Text
4. Screen Capture for Image Understanding
5. Speech to Text

**Dependencies**

- Alfred 5 [Powerpack](https://www.alfredapp.com/shop/)
- OpenAI [API key](https://platform.openai.com/account/api-keys)
- [Pandoc](https://pandoc.org/): to convert Markdown to HTML
- [MPV](https://mpv.io/): to play text-to-speech audio stream
- [Sox](https://sox.sourceforge.net/sox.html): to record voice input
- [jq](https://jqlang.github.io/jq/): to handle chat history in JSON
- [duti](https://github.com/moretension/duti): to detect the default web browser

To start using this workflow, you must set the environment variable `apikey`, which you can obtain by creating a new [OpenAI account](https://platform.openai.com/account/api-keys). See also the [Configuration](#configuration) section below.

You will also need to install the `pandoc` and `sox` programs. Pandoc allows this workflow to convert the Markdown response from OpenAI to HTML and display the result in your default web browser with syntax highlighting enabled (especially useful when using this workflow to generate program code). Sox allows you to record voice audio to convert to text using the Whisper speech-to-text API.

To set up dependencies (`pandoc`, `mpv`, `sox`, `jq`, and `duti`), first install [Homebrew](https://brew.sh/) and run the following command:

```shell
brew install pandoc mpv sox jq duti
```

**Change Log**

**Recent Change Log**

- 3.3.0: Import image feature is added to the web UI
- 3.2.3: Added support for `gpt-4o-2024-11-20` model
- 3.2.2: Streaming support for `o1` series models
- 3.2.1: Fixed URI encoding issue when re-editing prompt
- 3.2.0: Added support for Beta models (`o1-preview`, `o1-mini`)

[Complete Change Log](https://github.com/yohasebe/openai-chat-api-workflow/blob/main/CHANGELOG.md)

## Methods of Execution

Here are three methods to run the workflow: 1) Using commands within the Alfred UI, 2) Passing selected text to the workflow, 3) Utilizing the Web UI. Additionally, there’s a convenient method for making brief inquiries to GPT.

**Commands within the Alfred UI**

You can enter a query directly into Alfred's textbox:

- Method 1: Alfred textbox → keyword (`openai`) → space/tab → input query → select a command (see below)
- Method 2: Alfred textbox → input query → select fallback search (`OpenAI Query`)

**Passing Selected Text**

You can select any text on your Mac and send it to the workflow:

- Method 1: Select text → universal action hotkey → select `OpenAI Query`
- Method 2: Set up a custom hotkey to `Send selected text to OpenAI`

**Using Web Interface**

You can open the web interface:

- Method 1: Alfred textbox → keyword (`openai-webui`)
- Method 2: Set up a custom hotkey to `Open web interface`

**Using the Default Browser**

If your default browser is set to one of the following and the duti command is installed on your system, the web interface will automatically open in your chosen browser. If not, Safari will be used as the default.

- Google Chrome (Stable, Beta, Dev, etc.)
- Microsoft Edge (Stable, Beta, Dev, etc.)
- Brave Browser

Restart the OpenAI Workflow server by executing `openai-restart-server` in case the web UI does not work as expected after changing the default browser.

**Web UI Modes**

Switch modes (`light`/`dark`/`auto`) with the `Web UI Mode` selector in the settings.

<kbd><img width="700" src="./docs/img/web-interface-dark.png"></kbd>

**Simple Direct Query/Chat**

To quickly chat with GPT:

- Method 1: Type keyword `gpt` → space/tab → input query (e.g., "**gpt** what is a large language model?")
- Method 2: Set up a custom hotkey to `OpenAI Direct Query`

<img src='./docs/img/direct-query.png' style='width:700px;'/>
 
## Basic Commands

With `Direct Query`, the input text is sent directly to the OpenAI Chat API as a prompt. You can also create a query by prepending or appending text to the input.

<span><img src='./icons/patch-question.png' style='height:1em;'/></span> **Direct Query**

The input text is directly sent as a prompt to the OpenAI Chat API.

<kbd><img src='./docs/img/direct-query.gif' style='width:700px;'/></kbd>

<span><img src='./icons/arrow-bar-down.png' style='height:1em;'/></span> **Prepend Text + Query**

After entering the initial text, you are prompted for additional text. The additional text is added *before* the initial text, and the resulting text is used as the query.

<kbd><img src='./docs/img/prepend.gif' style='width:700px;'/></kbd>

<span><img src='./icons/arrow-bar-up.png' style='height:1em;'/></span> **Append Text + Query**

After entering the initial text, you are prompted for additional text. The additional text is added *after* the initial text, and the resulting text is used as the query.

<span><img src='./icons/picture.png' style='height:1em;'/></span> **Generate Image**

The DALL-E API (`dall-e-3` or `dall-e-2`) is used to generate images based on the entered prompts. See [Image Generation](#image-generation) below.

## Commands for Specific Purposes

Some of the examples shown on [OpenAI's Examples page](https://platform.openai.com/examples) are incorporated into this Workflow as commands. Functions not prepared as commands can be realized by giving appropriate prompts to the above [Basic Commands](#basic-commands).

<span><img src='./icons/code-square.png' style='height:1em;'/></span> **Write Program Code**

GPT generates program code and example output based on the entered text. You can specify the purpose of the program, its function, the language, and the technology to be used, etc.

**Example Input**

> Create a command line program that takes an English sentence and returns syntactically parsed output. Provide program code in Python and example usage.

**Example Output**

<kbd><img width="700" src="./docs/img/code.png"></kbd>

<span><img src='./icons/quora.png' style='height:1em;'/></span> **Ask in Your Language**

You can ask questions in the language set to the variable `first_language`.

**Note**: If the value of `first_language` is not `English` (e.g., `Japanese`), the query may result in a less accurate response.

<span><img src='./icons/translate.png' style='height:1em;'/></span> **Translate L1 to L2**

GPT translates text from the language specified in the variable `first_language` to the language specified in `second_language`.

<span><img src='./icons/translate.png' style='height:1em;'/></span> **Translate L2 to L1**

GPT translates text from the language specified in the variable `second_language` to the language specified in `first_language`.

<span><img src='./icons/pencil.png' style='height:1em;'/></span> **Grammar Correction**

GPT corrects sentences that may contain grammatical errors. See OpenAI's [description](https://beta.openai.com/examples/default-grammar).

<span><img src='./icons/lightbulb.png' style='height:1em;'/></span> **Brainstorm**

GPT assists you in brainstorming innovative ideas based on any given text.

<span><img src='./icons/book.png' style='height:1em;'/></span> **Create Study Notes**

GPT provides study notes on a given topic. See OpenAI's [description](https://beta.openai.com/examples/default-study-notes) for this example.

<span><img src='./icons/arrow-left-right.png' style='height:1em;'/></span> **Analogy Maker**

GPT creates analogies. See OpenAI's [description](https://beta.openai.com/examples/default-analogy-maker) for this example.

<span><img src='./icons/list-ul.png' style='height:1em;'/></span> **Essay Outline**

GPT generates an outline for a research topic. See OpenAI's [description](https://beta.openai.com/examples/default-essay-outline) for this example.

<span><img src='./icons/chat-left-quote.png' style='height:1em;'/></span> **TL;DR Summarization**

GPT summarizes a given text. See OpenAI's [description](https://beta.openai.com/examples/default-tldr-summary) for this example.

<span><img src='./icons/emoji-smile.png' style='height:1em;'/></span> **Summarize for a 2nd Grader**

GPT translates complex text into more straightforward concepts. See OpenAI's [description](https://beta.openai.com/examples/default-summarize) for this example.

<span><img src='./icons/key.png' style='height:1em;'/></span> **Keywords**

GPT extracts keywords from a block of text. See OpenAI's [description](https://beta.openai.com/examples/default-keywords) for this example.

## Image Generation

Image generation can be executed through one of the above commands. It is also possible to use the web UI. By using the web UI, you can interactively change the prompt to get closer to the desired image.

<kbd><img width="700" src="./docs/img/image-generation-1.png"></kbd>

When the image generation mode is set to `dall-e-3`, the user's prompt is automatically expanded to a more detailed and specific prompt. You can also edit the expanded prompt and regenerate the image.

<kbd><img width="700" src="./docs/img/image-generation-2.png"></kbd>

<kbd><img width="700" src="./docs/img/image-generation-3.png"></kbd>

## Image Understanding

Image understanding can be executed through the `openai-vision` command. It starts capture mode and lets you specify a part of the screen to be analyzed. Alternatively, you can specify an image file (jpg, jpeg, png, gif) using the "OpenAI Vision" file action. This mode requires the `gpt-4o` or `gpt-4o-mini` model to be set in the workflow settings.

<kbd><img src="./docs/img/openai-workflow-vision.gif" width="700"></kbd>

Alternatively, you can use the web UI to upload an image file for analysis. The image file is sent to the OpenAI Vision API, and the result is displayed in the web UI.

<kbd><img src="./docs/img/openai-vision-web-ui.png" width="700"></kbd>


## Speech Synthesis and Speech Recognition

Most text-to-speech and speech-to-text features are available on the web UI. However, there are certain specific features provided as commands, such as audio file to text conversion and transcription with timestamps.

<kbd><img width="700" src="./docs/img/speech-to-text-web.png"></kbd>

**Text-to-Speech Synthesis**

Text entered or response text from GPT can be read out in a natural voice using OpenAI's text-to-speech API.

- Method 1: Press the `Play TTS` button on the web UI
- Method 2: Select text → universal action hotkey → select `OpenAI Text-to-Speech`

**Speech-to-Text Conversion**

The Whisper API can convert speech into text in a variety of languages. Please refer to the [Whisper API FAQ](https://help.openai.com/en/articles/7031512-whisper-api-faq) for available languages and other limitations.

- Method 1: Press the `Voice Input` button on the web UI
- Method 2: Alfred textbox → keyword (`openai-speech`)

**Audio File to Text**

You can select an audio file in `mp3`, `mp4`, `flac`, `webm`, `wav`, or `m4a` format (under 25MB) and send it to the workflow:

- Select the file → universal action hotkey → select `OpenAI Speech-to-Text`

**Record Voice Audio and Transcribe**

You can record voice audio and send it to the Workflow for transcription using the Whisper API. Recording time is limited to 30 minutes and will automatically stop after this duration.

<kbd><img width="700" alt="transcript-srt" src="./docs/img/speech-to-text.png"></kbd>

- Alfred textbox → keyword (`openai-speech`) → Terminal window opens and recording starts
- Speak into the internal or external microphone → Press Enter to finish recording
- Choose processes to apply to the recorded audio:

  - Transcribe (+ delete recording)
  - Transcribe (+ save recording to desktop)
  - Transcribe and query (+ delete recording)
  - Transcribe and query (+ save recording to desktop)
  - Exit (+ delete recording)
  - Exit (+ save recording to desktop)

You can choose the format of the transcribed text as `text`, `srt`, or `vtt` in the workflow's settings. Below are examples in the `text` and `srt` formats:

<kbd><img width="700" alt="transcript-text" src="./docs/img/transcript-text.png"></kbd>

<kbd><img width="700" alt="transcript-srt" src="./docs/img/transcript-srt.png"></kbd>

## Other Features

**Import/Export**

You can export your chat data to a straightforward JSON format file and resume your conversation later by importing it back in.

To export data, simply click on `Show Entire Chat` in the chat window to navigate to the chat history page, then select `Export Data`. To import data, just click `Import Data` on either the home page or the chat history page.

**Monitor API Usage**

To review your token usage for the current billing cycle on the OpenAI Usage Page, type the keyword `openai-usage`. For more details on billing, visit OpenAI's [Billing Overview](https://platform.openai.com/account/billing/overview).

## Configuration Parameters

You can set various parameters in the settings panel of this Workflow. Some of the parameters set here are used as default values, but you can make temporary changes to the values on the web UI. You can also access the settings panel by clicking `Open Config` from the web UI.

**Required Settings**

- **OpenAI API Key**: Set your secret API key for OpenAI. Sign up for OpenAI and get your API key at [https://platform.openai.com/account/api-keys/](https://platform.openai.com/account/api-keys).
- **Base URL**: The base URL of the OpenAI Chat API. (default: `https://api.openai.com/v1`)

**Web UI Parameters**

- **Loopback Address**: Either `localhost` or `127.0.0.1` can be used as the loopback address of the UI server. If the web UI does not work as expected, try the other. (default: `127.0.0.1`)
- **Stream Output**: Show results in the default web browser. If unchecked, Alfred's "Large Type" feature is used to display the result. (default: `enabled`)
- **Hide Speech Buttons**: When enabled, the buttons for TTS playback and voice input are hidden on the web UI.
- **Web UI Mode**: Set your preferred UI mode (`light`/`dark`/`auto`). (default: `auto`)

**Chat Parameters**

- **Model**: OpenAI's chat [model](https://beta.openai.com/docs/api-reference/models) used for the workflow (default: `gpt-4o-mini`). Here are some of the models currently available:
  - `gpt-4o-mini`
  - `chatgpt-4o-latest`
  - `gpt-4o-2024-08-06`
  - `gpt-4o`
  
  You may or may not use the following beta models. System prompt and parameter settings are not available for these models.
  - `o1-preview`
  - `o1-mini`
  
- **Max Tokens**: Maximum number of tokens to be generated upon completion (default: `2048`). If this parameter is set to `0`, `null` is sent to the API as the default value (the maximum number of tokens is not specified). See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-max_tokens).
- **Temperature**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-temperature). (default: `0.3`)
- **Top P**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-top_p). (default: `1.0`)
- **Frequency Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-frequency_penalty). (default: `0.0`)
- **Presence Penalty**: See OpenAI's [documentation](https://beta.openai.com/docs/api-reference/chats/create#chats/create-presence_penalty). (default: `0.0`)
- **Memory Span**: Set the number of past utterances sent to the API as context. Setting `4` for this parameter means 2 conversation turns (user → assistant → user → assistant) will be sent as context for a new query. The larger the value, the more tokens will be consumed. (default: `10`)
- **Max Characters**: Maximum number of characters that can be included in a query (default: `50000`).
- **Timeout**: The number of seconds (default: `10`) to wait before opening the socket and connecting to the API. If the connection fails, reconnection (up to 20 times) will be attempted after 1 second.
- **Add Emoji**: If enabled, the response text from GPT will contain emoji characters appropriate for the content. This is realized by adding the following sentence at the end of the system content. (default: `enabled`)
  
  > Add emojis that are appropriate to the content of the response.
  
- **System Content**: Text to send with every query sent to the API as general information about the specification of the chat. The default value is as follows:
  
  > You are a friendly but professional consultant who answers various questions, makes decent suggestions, and gives helpful advice in response to a prompt from the user. Your response must be concise, suggestive, and accurate.

**Image Understanding Parameters**

- **Max Size for Image Understanding**: The maximum pixel value (`512` to `2000`) of the larger side of the image data sent to the image understanding API. Larger images will be resized accordingly. (Default: `512`)

**Image Generation Parameters**

- **Image Generation Model**: `dall-e-3` and `dall-e-2` are available. (default: `dall-e-3`)
- **Image Size** (for `dall-e-3`): Set the size of images to generate to `1024x1024`, `1024x1792`, or `1792x1024`. (default: `1024x1024`)
- **Quality** (for `dall-e-3`): Choose the quality of the image from `standard` and `hd`. (default: `standard`)
- **Style** (for `dall-e-3`): Choose the style of the image from `vivid` and `natural`. (default: `vivid`)
- **Number of Images** (for `dall-e-2`): Set the number of images to generate in image generation mode from `1` to `10`. (default: `1`)
- **Image Size** (for `dall-e-2`): Set the size of images to generate to `256x256`, `512x512`, or `1024x1024`. (default: `256x256`)

**Text-to-Speech Parameters**

- **Text-to-Speech Model**: One of the available TTS models: `tts-1` or `tts-1-hd`. (default: `tts-1`)
- **Text-to-Speech Voice**: The voice to use when generating the audio. Supported voices are: `alloy`, `echo`, `fable`, `onyx`, `nova`, and `shimmer`. (default: `alloy`)
- **Text-to-Speech Speed**: The speed of the generated audio. Select a value from 0.25 to 4.0. (default: `1.0`)
- **Automatic Text to Speech**: If enabled, the results will be read aloud using the system's default text-to-speech language and voice. (default: `disabled`)

**Speech-to-Text Parameters**

- **Transcription Format**: Set the format of the text transcribed from the microphone input or audio files to `text`, `srt`, or `vtt`. (default: `text`)
- **Processes after Recording**: Set the default choice of what processes follow after audio recording finishes. (default: `Transcribe [+ delete recording]`).
  
  - Transcribe [+ delete recording]
  - Transcribe [+ save recording to desktop]
  - Transcribe and query [+ delete recording]
  - Transcribe and query [+ save recording to desktop]
  
- **Audio to English**: When enabled, the Whisper API will transcribe the input audio and output text translated into English. (default: `disabled`)

**Other Settings**

- **Your First Language**: Set your first language. This language is used when using GPT for translation. (default: `English`)
- **Your Second Language**: Set your second language. This language is used when using GPT for translation. (default: `Japanese`)
- **Sound**: If checked, a notification sound will play when the response is returned. (default: `disabled`)
- **Save File Path**: If set, the results will be saved in the specified path as a markdown file. (default: `not set`)

**Environment Variables**

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
