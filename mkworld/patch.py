import os
import json
import typing
import time

"""
[
    {
        "id": "0f6b6dd",
        "objtype": "world",
        "roots": [
            {
                "identity": "0f632ab6dd:0:11a9a27a2f6c6b9ad87fcd730609967b65fa6d9e57cb032e7c2ad413324be0d569cf3feb391206559a5e3e8979a5bf5cb1b96c8377b83bf8c0a3acd9f089",
                "stableEndpoints": [
                    "2.17.8.23/994"
                ]
            }
        ],
        "signingKey": "3323f64821bcd959470e8abe1e3edaa0cd1c47623cb3811e718f9ac60695f3bf0f735389dacb9cd7af3b3710c79f3af6cfdc997c2e8e85e52d38c6d96d7",
        "signingKey_SECRET": "16921f1f8359c399c7db0c1f2bd40c0fbc286d30ee8ebf9063e7d39e4dc35245fc9485cb620313ebfee483b4b26158d6c7998cf3ab88e6d1b34dd45bda6",
        "updatesMustBeSignedBy": "3323f64821bcd959470e8aedaa0cd1e931cc47623cb3811e718f9ac60695f3bf0f735389dacb9cd7af3b3710c79f3af6cfdc997c2e8e85e52d38c6d96d7",
        "worldType": "moon"
    }
]"""

def patch(configs:typing.List[dict]):
    if not configs:
        print("configs is empty")
        exit(1)
    if isinstance(configs,list):
        print("configs is not list")
        exit(1)

    text=""
    for i in configs:
        identity=i["roots"][0]["identity"]
        t=f"""//
	roots.push_back(World::Root());
	roots.back().identity = Identity("{identity}");
"""
        for j in i["roots"][0]["stableEndpoints"]:
            t+=f'\n        roots.back().stableEndpoints.push_back(InetAddress("{j}"));'
        text+=t

    print(f"host configs is:\n{text}\n")

    with open("mkworld.cpp", "r") as cpp:
        world = "".join(cpp.readlines())
        world = world.replace("//__PATCH_REPLACE__", text)
    
    with open("/app/ZeroTierOne/attic/world/mkworld.cpp", "w") as cpp:
        cpp.write(world)
        print("patch success")


def main():
    print("输入planet的配置文本(粘贴后按最后一行为回车结束输入):")
    lines = []
    while True:
        line = input()
        if not line:
            break  # 如果用户输入空行，则退出循环
        lines.append(line)

    planet_config="".join(lines)

    if not planet_config:
        print("planet_config is empty")
        exit(1)
    
    try:
        print("你输入的内容为:\n",json.dumps(json.loads(planet_config), indent=4))
        print("3s后将继续...")

        time.sleep(3)

        configs=json.loads(planet_config)
        patch(configs)

    except Exception as e:
        print(e)
        exit(1)


if __name__ == '__main__':
    main()