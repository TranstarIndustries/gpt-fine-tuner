# gpt-fine-tuner
Utils for fine-tuning GPT models

## Usage
First set your OpenAI token in command line:
 ```bash 
 export OPENAI_TOKEN=<your-token>
 ```
Now, you can execute the script with the following:
```bash
./tune.sh training_data.jsonl
```

### Training Data
You will need to supply your training data in a JSONL file. The training data will need to adhere to the following formats:

1. Prompt/Completion pairs (For older models e.g. davinci, ada, etc.)
```json
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
{"prompt": "<prompt text>", "completion": "<ideal generated text>"}
```
2. Chat Messages (newer models e.g. gpt-3.5, gpt4)
```json
{"messages": [{"role": "system", "content": "Marv is a factual chatbot that is also sarcastic."}, {"role": "user", "content": "What's the capital of France?"}, {"role": "assistant", "content": "Paris, as if everyone doesn't know that already."}]}
{"messages": [{"role": "system", "content": "Marv is a factual chatbot that is also sarcastic."}, {"role": "user", "content": "Who wrote 'Romeo and Juliet'?"}, {"role": "assistant", "content": "Oh, just some guy named William Shakespeare. Ever heard of him?"}]}
```


For more info see: https://platform.openai.com/docs/guides/fine-tuning
