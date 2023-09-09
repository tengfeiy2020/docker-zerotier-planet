import os 
import json

def get_moon_file():
    with open("/var/lib/zerotier-one/moon.json", "r") as f:
        moon = json.load(f)
        return moon
    
def get_patch_file():
    with open("/app/patch.json", "r") as f:
        return json.load(f)

def update_moon_file():
    moon = get_moon_file()
    patch = get_patch_file()

    moon["roots"][0]["stableEndpoints"] = patch["stableEndpoints"]
    with open("/var/lib/zerotier-one/moon.json", "w") as f:
        f.write(json.dumps(moon,sort_keys=True, indent=2))

    print("修改后的moon")
    print(json.dumps(moon))

def main():
    update_moon_file()


if __name__ == '__main__':
    main()