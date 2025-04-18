# Change Log

- 3.6.8:
  - Web UI color scheme improved
  - `o4-mini` and `o3` models supported
  - `gpt-4.1` series models supported and `gpt-4.1-mini` set as default
  - Image recognition and understanding features from web UI improved
- 3.6.4:
  - New speech-to-text models `gpt-4o-mini-transcribe` (default) and `gpt-4o-transcribe` supported
  - New text-to-speech model `gpt-4o-mini-tts` supported (default)
  - Added "TTS instruction" feature for character and speaking style control
  - Added web search capability (triggered by "search" at the beginning of prompt)
  - New TTS voice `ballad` added
- 3.6.3:
  - Universal action image understanding feature supports PDF files
  - `gpt-4.5-preview` model supported
  - Text-to-speech replacement CSV support added
- 3.5.3:
  - Reasoning effort parameter added for `o1` and `o3-mini` models
  - `o1` model streaming supported
  - Web UI better reflects the parameters set in the workflow settings
- 3.4.7: 
  - The `reasoning_effort` parameter is added for reasoning models (`o1` and `o3-mini`)
  - `o3-mini` model supported (streaming)
  - `o1` model supported (non-streaming only)
  - Image upload from the web UI improved
  - Command-line recording for speech-to-text fixed (Thank you Victor)
- 3.4.1:
  - New TTS voices added (`ash`, `coral`, and `sage`)
  - Old models before `gpt-4o` are removed
  - UI improvements
- 3.3.0: Import image feature is added to the web UI
- 3.2.3: Added support for `gpt-4o-2024-11-20` model
- 3.2.2: Streaming support for `o1` series models
- 3.2.1: URI encoding issue when re-editing prompt fixed
- 3.2.0: Beta models (`o1-preview`, `o1-mini`) supported
- 3.1.4: `chatgpt-4o-lateset` supported
- 3.1.3: `gpt-4o-2024-08-06` supported; `gpt-3.5` series models unsupported;
- 3.1.2: `gpt-4o-mini` supported;
- 3.0.1: Default for `Memory Span` set to `10`
- 3.0.0: `gpt-4o` supported;
- 2.9.9.5: Access to cancel button in web UI improved
- 2.9.9.4: Smoother response text streaming; `max_tokens` can be set to `0` (set to `null`);
- 2.9.9.2: `gpt-4-turbo-2024-04-09` supported;
- 2.9.9.1: system prompt modifiable in the web UI
- 2.9.9: Issue concerning chat containing images fixed
- 2.9.8: JSON export and cancel button behavior improved
- 2.9.7: Stability improvements; Brave browser supported
- 2.9.6: System prompt modifiable in the web UI
- 2.9.5: `gpt-3.5-turbo-0125` supported (default model)
- 2.9.4: Copy code snippet button; fix dark mode issue
- 2.9.2: Default model set to `gpt-3.5-turbo-1106`; New model (`gpt-4-0125-preview`) supported
- 2.9.0: Image understanding (using specified files or screen captures)
- 2.8.8: Whisper error handling improved
- 2.8.7: Dark mode UI issue fixed
- 2.8.6: Added option to hide speech buttons
- 2.8.5: Improved support for Safari
- 2.8.3: Loopback address for web UI can be chosen from `127.0.0.1` or `localhost`
- 2.8.0: Web UI hosted by a server running within workflow
    - Several usability improvements
    - Bug fixes in the automatic speech-to-speech feature
- 2.7.2: Improved streaming TTS playback
    - Requires `brew install mpv`
    - Works on Chrome, Edge, and Safari
    - "Set Voice" button added
    - "Auto Play" button added
- 2.6.3: Usability improvements 
    - Streaming TTS playback for Chrome and Edge browsers
    - "Edit Prompt" button for generated image
    - Web UI focus status indicator added
- 2.6.2: OpenAI's 2023-1106 models supported
    - chat/completion
        - gpt-4-1106-preview
        - gpt-3.5-turbo-1106
    - image generation
        - dall-e-3
    - text-to-speech
        - tts-1
        - tts-1-hd
- 2.4.0: Many improvements in stability and UI
    - Improved API calls and websocket connections
    - Improved handling of invalid characters
    - Cancel button in web interface
    - TTS play/stop from web interface
    - Edit button added to last message
    - Checkbox for adding Emoji to response from GPT
    - Auto-resize textarea
- 2.3.5: UI mode option (light/dark/auto) added 🎃
- 2.2.5: Check-for-update feature added
- 2.2.4: Added the ability to export/import chat history 💾
- 2.1.2: Added the ability to stream text responses from GPT 🤖💬
- 2.0.3: Resolved a CSS loading issue on Safari.
- 2.0.0: Introduced support for interactive chat with GPT.
- 1.12.0: Introduced a popup model selector.
- 1.11.3: Fixed an issue with the speech-to-text file action.
- 1.11.2: Added a new keyword (gpt) for simple queries.
- 1.11.0: Added support for speech-to-text using the Whisper API.
- 1.10.2: The Enhance Prompt feature now supports both gpt-4 and gpt-3.5-turbo.
- 1.10.0: Added the Enhance Prompt option for image generation mode.
- 1.9.1: Fixed an issue with 1024x1024 image generation.
- 1.9.0: Image generation using DALL·E API supported
- 1.8.2: New models (`gpt-3.5-turbo-0613`, `gpt-3.5-turbo-16k-0613`, `gpt-4-0613`) supported
- 1.8.1: Added option to change base URL of the OpenAI API
- 1.8.0: Custom CSS feature added
- 1.7.0: Improved UI
- 1.6.9: GPT-4 models (e.g. `gpt-4`) supported
- 1.6.7: Fixed an error that occurred for some users
- 1.6.6: Debug mode added that outputs error messages when problems occur
- 1.6.5: Automatic detection of Pandoc installation
- 1.6.4: Suppress "Please Wait" message feature
- 1.6.3: OpenAI Textbox feature updated
- 1.6.0: `GPT-3.5-turbo` model is set to the default
- 1.6.0: ChatGPT API support
- 1.6.0: HTML output option (using Pandoc) is enabled by default
- 1.6.0: check-for-update command removed (in preparation for Alfred Gallery incousion)
- 1.5.2: Verification dialog removed; `speak` option fixed
- 1.5.1: Easy MarkDown Editor enabled
- 1.4.0: "OpenAI Textbox" feature added
- 1.3.0: "Write Program Code" feature added
- 1.3.0: `pandoc` option added
- 1.2.0: check-for-update command added
- 1.1.3: Include original prompt in the response
- 1.1.1: `text-davinci-003` model added and made default 
- 1.1.0: "Ask in Your Language" feature added
- 1.0.0: Initial release
