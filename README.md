Execute the following commands to build the accelerate3g5 CN stack:

```    
repo init -u https://github.com/blobbsen/repo-handson -m accelerate3g5.xml
repo sync
.repo/manifests/build_accelerate3g5.sh
```

For more information:

```
git clone https://github.com/blobbsen/repo-handson.git
cd repo-handson
git log
```    

Note: One should *not* clone the "repo-handson" repo inside the directory, where repo init... has been executed.
