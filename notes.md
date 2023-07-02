<div align="center">
	<p>
	<img alt="Thoughtworks Logo" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/thoughtworks_flamingo_wave.png?sanitize=true" width=200 /><br />
	<img alt="DPS Title" src="https://raw.githubusercontent.com/ThoughtWorks-DPS/static/master/EMPCPlatformStarterKitsImage.png?sanitize=true" width=350/><br />
	<h2>psk-platform-global-env-values</h2>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/github/license/ThoughtWorks-DPS/psk-platform-global-env-values"></a> <a href="https://aws.amazon.com"><img src="https://img.shields.io/badge/-deployed-blank.svg?style=social&logo=amazon"></a>
	</p>
</div>

### Notes for gloval_values.json elements

#### control-plane-deployent

Defines roles and related instances for the global deployment of control-plane resources. The empc lab maintains a very small footprint and normally at such a small scale use of the scaled-environment practices is not warrented. The lab has only two roles and only a single instance of the control-plane per role. We are using the workflow logic of a larger deployment just for demonstration purposes.  

In a larger enterprise setting the path to production for an engineering platform will typically have the following stages:

**sandbox**  :  this represents the non-customer facing instances of the platform, used by the EP product team to develop and test the features of the engineering platform. All such additions, along with upgrades, patches, etc for existing components are first deployed and tested in Sandbox instances of the platform.  

sbx-dev  >  sbx-qa  > sbx-mapi  

**release**  :  Successful changes to the sandbox instances would result in triggering the general "release to production" path:  

preview  >  nonprod  >  prod  >  mapi  

Yet, at scale, each of these _environments_ can have multiple VPCs and multiple Kubernetes clusters across multiple regions. Hence "deploying" to preview can mean targeting multiple discrete deployments to multiple instances of similar infrastructure.  

Ex:  

Assume an engineering platform in AWS supports the following regions `us-east-1, us-west-2, eu-central-1, eu-west-1, ap-east-1, ap-southeast-2` then deploying an EKS upgrade will mean managing a version upgrade to six EKS clusters not just one. And typically some or all of such clusters concurrently.  

The control-plane-deployment collects these cluster instances within named groups so that release pipelines can be structured dynamically push changes based on the values within this global config rather than being a hard-coded attribute of the pipeline.  

So continuing with the example of six regions, the control-plane-deployment value could look like this:  
```json
{
    "sandbox": {
        "sbx-dev": [
            "sbx-dev-i01-aws-us-east-1",
            "sbx-dev-i01-aws-eu-west-1"
        ],
        "sbx-qa": [
            "sbx-qa-i01-aws-us-east-1",
            "sbx-qa-i01-aws-eu-west-1"
        ],
        "sbx-mapi": [
            "sbx-mapi-i01-aws-us-east-1"
        ]
    },
    "platform": {
        "preview": [
            "preview-i01-aws-us-east-1",
            "preview-i01-aws-us-west-2",
            "preview-i01-aws-eu-central-1",
            "preview-i01-aws-eu-west-1",
            "preview-i01-ap-east-1",
            "preview-i01-ap-southeast-2",
            "mapi-i01-aws-us-east-2",
            "mapi-i01-aws-eu-west-3"
        ],
        "nonprod": [
            "nonprod-i01-aws-us-east-1",
            "nonprod-i01-aws-us-west-2",
            "nonprod-i01-aws-eu-central-1",
            "nonprod-i01-aws-eu-west-1",
            "nonprod-i01-ap-east-1",
            "nonprod-i01-ap-southeast-2"
        ],
        "prod": [
            "prod-i01-aws-us-east-1",
            "prod-i01-aws-us-west-2",
            "prod-i01-aws-eu-central-1",
            "prod-i01-aws-eu-west-1",
            "prod-i01-ap-east-1",
            "prod-i01-ap-southeast-2"
        ]
    }
}
```
Using this config, you can trigger a sandbox deployment pipeline on git-push and a platform deployment pipeline on git-tag, and the `generated` pipeline would know that deploying to "preview" means concurrently deploying to all the locations listed. Likewise, upon successful completion, either with a manual approval or automatically, the pipeline would then go on to deploy to all six locations in "nonprod" and so on. (In this PSK build, only a single sandbox instance and prod instance is defined.)
