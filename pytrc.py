
pyt_global.PYT_OUT = "/data/0/pyt/out"
pyt_global.PYT_IN = "/data/0/pyt/in"
pyt_global.PYT_SKETCH = "/data/0/pyt/sketch"

pyt_global.favorite_dirs = {
    "data0": "/data/0",
    "data1": "/data/1",
    "data2": "/data/2",
    "ssd0": "/ssd/0",
    "pyt": "/data/0/code/python/snakepyt",
    "out": "/data/0/pyt/out",
    "in": "/data/0/pyt/in",
    "code": "/data/0/code",
    "media": "/data/0/media",
    "crone": "/data/0/code/c/crone",
    "dots": "/home/ponder/ponder/dots"
}

@register_command("llms")
def cmd_llama_server(_, args):
    import subprocess

    subprocess.Popen(
        ['alacritty', '--working-directory', '/ssd/0/llm', '-e', 'bash', '-c', './launch; exec bash'],
        start_new_session=True
    )
    _.log("llama launched!")

