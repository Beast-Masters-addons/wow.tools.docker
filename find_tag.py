import requests
from packaging.version import Version

response = requests.get('https://github.com/Marlamin/wow.tools.local')

highest = None
highest_tag = None

for tag in response.json():
    version = Version(tag['name'])
    if not highest or version > highest:
        highest = version
        highest_tag = tag

print('package_version=%s' % highest_tag['name'], end='')
