# Bosh release for ClamAV

If you need the [ClamAV](https://www.clamav.net/) anti-virus product in your infrastructure then deploy this BOSH release.

## Usage

### Create & Upload the BOSH release

To use this BOSH release, first create the dev release, then the final release, then upload it to your BOSH director:

```
bosh target BOSH_HOST
git clone https://github.com/emc-cloudfoundry/clamav-boshrelease.git
cd clamav-boshrelease
bosh create release --force
bosh create release --force --final
bosh upload release
```

### Create a BOSH deployment manifest

Please refer to the file example-manifest.yml for an example of the deployment manifest.

### Deploy using the BOSH deployment manifest

Using the previous created deployment manifest, now we can deploy it:

```
bosh deployment path/to/deployment.yml
bosh -n deploy
```

#### Proxy support

If your vms require a proxy in order to get internet access to fetch the ClamAV virus definition updates, set the properties clamav.proxyHost and clamav.proxyPort to the Host/IP and Port number of the proxy.


