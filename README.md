d710 Build Instructions
=======================
```
mkdir -p android/CM9
cd android/CM9
repo init -u git://github.com/CyanogenMod/android.git -b ics
```
You will need to get the d710 proprietary files. Run the extract script from a current working CM9 build 

Modify your `.repo/local_manifest.xml` as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <manifest>
    <project name="EpicCM/d710tools.git" path="d710tools" remote="github" revision="ics" />
    <project name="dastin1015/android_device_samsung_d710" path="device/samsung/d710" remote="github" revision="cm-10.1" />
    <project name="dastin1015/android_kernel_samsung_smdk4210" path="kernel/samsung/smdk4210" remote="github" revision="cm-10.1" />
    <project name="ProjectOpenCannibal/android_device_lge_ls840" path="device/lge/ls840" remote="github" revision="cm-10.1" />
    <project name="thenameisnigel/android_kernel_lge_ls840" path="kernel/lge/ls840" remote="github" revision="cm-10.1" />
    <project name="TheMuppets/proprietary_vendor_samsung" path="vendor/samsung" remote="github" revision="cm-10.1 />
    <project name="ProjectVendor/proprietary_vendor_lge" path="vendor/lge" remote="github" revision="ics" />
  </manifest>
```

```
repo sync
vendor/cm/get-prebuilts
```

Auto Apply Patches
==================
This script will remove any topic branches named auto, then apply all patches under topic branch auto.

```
d710tools/apply.sh
```

Build
=====
```
. build/envsetup.sh && brunch cm_d710-userdebug
```
