[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Issues](https://img.shields.io/github/issues/peregin/connectiq-time-battery.svg)](https://github.com/peregin/connectiq-time-battery/issues)

Garmin data field with time of day, battery and temperature information
===

The data field shows the current time of day as main indicators.
On the top of the field it displays the battery level.

![edge830](https://raw.github.com/peregin/connectiq-time-battery/master/doc/edge830.png "edge830")
&nbsp;
![edge1040](https://raw.github.com/peregin/connectiq-time-battery/master/doc/edge1040.png "edge1040")

Build
---
Don't forget to update the version number in the manifest.xml file.
Build package ready to deploy to Garmin App store.
```shell
make package
```

Manual Deployment
---

Copy the prg file over the `/GARMIN/APPS/` folder.

Compatible Devices
---
https://developer.garmin.com/connect-iq/compatible-devices/
