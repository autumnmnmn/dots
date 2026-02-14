
@register_command("llama_server")
def cmd_llama_server(_, args):
    import subprocess

    subprocess.Popen(
        ['alacritty', '--working-directory', '/ssd/0/llm', '-e', 'bash', '-c', './launch; exec bash'],
        start_new_session=True
    )
    _.log("llama launched!")

