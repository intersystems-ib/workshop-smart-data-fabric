Learn the foundamentals to implement an Smart Data Fabric architect using InterSystems IRIS.

<img src="img/sdf.png" width="1500"/>

# Learn the basics
👉 We will combine different features of InterSystems IRIS such as multi-model database, interoperability and analytics.

If you are not too familiar with InterSystems IRIS technology, you can get a hands-on overview with these resources:
* Learn about InterSystems IRIS and **Docker containers** - [workshop-containers-intro](https://github.com/intersystems-ib/workshop-containers-intro)
* Learn how to use InterSystems IRIS and Visual Studio Code - [workshop-vscode-iris](https://github.com/intersystems-ib/workshop-vscode-iris)
* A very simple introduction to InterSystems IRIS **multi-model database** -  [workshop-multimodel-intro](https://github.com/intersystems-ib/workshop-multimodel-intro)
* An overview of **interoperability** using IRIS - [workshop-interop-intro](https://github.com/intersystems-ib/workshop-interop-intro)
* Analytics & BI in a nutshell with IRIS - [workshop-iris-bi-intro](https://github.com/intersystems-ib/workshop-iris-bi-intro)

# What do you need to install? 
* [Git](https://git-scm.com/downloads) 
* [Docker](https://www.docker.com/products/docker-desktop) (if you are using Windows, make sure you set your Docker installation to use "Linux containers").
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) + [InterSystems ObjectScript VSCode Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)

# Setup
Clone the GitHub repository to your local computer. This will allow you to acces the code and build the samples:
```
git clone https://github.com/intersystems-ib/workshop-smart-data-fabric
``` 

Build the image we will use during the workshop:
```
docker-compose build
```

Run the container:
```
docker-compose up -d
```

You should be able to access [InterSystems IRIS Management Portal](http://localhost:52773/csp/sys/UtilHome.csp) and login using `superuser` / `SYS`.

# Environment
We are going to use an environment using Docker containers. 

<img src="img/docker-environment.png" width="800" />

* [docker-compose](docker-compose.yml) - set up the containers (services) we are using.
* [Dockerfile](Dockerfile) - this file defines how we are building our InterSystems IRIS Container. We will start from an InterSystems IRIS For Health Community version, copy some directories, set up some permissions and finally call `iris.script` to run whatever we need within IRIS.
* [iris.script](iris.script) - script that runs the setup we need in IRIS, e.g. installing applications, loading source code, etc.

After running the environment, you can access to an interactive sesion on IRIS container using:
```
docker-compose exec -it iris bash
```

You can also have a look at the container logs using:
```
docker logs iris
```

# Data model
Have a look at the main classes of our data model:
* [Patient](src/sdf/data/Patient.cls) will store patient definitions
* [Observation](src/sdf/data/Observation.cls) will store different kind of observations for the patients (e.g. diastolic bp, systolic bp, body temperature, etc.)

Our classes are [persistent](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GOBJ_persobj_intro). That means that they can store data, and in InterSystems IRIS we will be able to work with them using objects as well as SQL automatically.

These classes also use [Relationships](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GOBJ_relationships) and some [Indexes](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GOBJ_relationships). They can also contain methods and logic.

Go to [System Explorer > SQL (SDF)](http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen?$NAMESPACE=SDF&$NAMESPACE=SDF&#), locate the tables corresponding to our persistent classes and display them. They should be empty.

<img src="img/sql-explorer-empty.gif" width="1024"/>

We manipulate data using SQL or Objects. Let's create some simple data using objects through the [WebTerminal](http://localhost:52773/terminal/)

First, create a patient object:

```objectscript
    set patientObj = ##class(sdf.data.Patient).%New()
    set patientObj.Identifier = "12345"
    set patientObj.FirstName = "John"
    set patientObj.LastName = "Doe"
```

Then, create an observation for the patient:

```objectscript
    set obxObj = ##class(sdf.data.Observation).%New()
    set obxObj.Code = "BodyTemp"
    set obxObj.ValueNM = "36"
    set obxObj.Units = "C"
```

Finally, insert the observation into the patient record and save it

```objectscript
    do patientObj.Observations.Insert(obxObj)
    set sc = patientObj.%Save(1)
    write !,"statusCode=",sc
```

After that, try to run SQL queries again. You can also take advantage of [Implicit Joins (Arrow Syntax)](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GSQL_implicitjoins):

```sql
SELECT 
Patient->FirstName, Patient->LastName,Code, Units, ValueNM
FROM sdf_data.Observation
```

After your tests, delete all the data you have just created:

```objectscript
    write ##class(sdf.data.Observation).%KillExtent()
    write ##class(sdf.data.Patient).%KillExtent()
``` 

# Ingestion

## Data
* In our example, we are going to use a set of HL7 files that have been generated inspired on [Maternal Health Risk Data](https://www.kaggle.com/datasets/csafrit2/maternal-health-risk-data) dataset on Kaggle. These files will be ingested as they were incoming from an external hospital.
* Uncompress [data/hl7files.tar.gz](data/hl7files.tar.gz).

```
cd data
tar -zxvf hl7files.tar.gz
```

## DataPipe and DataPipeUI
* You could implement data ingestion in a lot of different ways. In this example, we will be using a community tool called [DataPipe](https://github.com/intersystems-ib/iris-datapipe) that is already installed in the environment. 
* This will help us on enriching, normalizing and validating the incoming data using InterSystems IRIS interoperability features. 
* Also you can use an user interface [DataPipeUI](https://github.com/intersystems-ib/iris-datapipeUI) to have a look at the incoming data to the system and how it's being handled.
* In a separate terminal in your system, clone the repo and run the [DataPipeUI](https://github.com/intersystems-ib/iris-datapipeUI) container user interface:

```
git clone https://github.com/intersystems-ib/iris-datapipeUI
cd iris-datapipeUI
docker-compose up -d
```

## Try ingesting some data yourself
* In the environment, open the [production](http://localhost:52773/csp/sdf/EnsPortal.ProductionConfig.zen?PRODUCTION=sdf.connectors.interop.Production). It is already running.
* Let's ingest some data.
* Copy some files from [data/hl7files](data/hl7files) into [data/hl7in](data/hl7in).
* You can have a look at the [HL7 messages processed](http://localhost:52773/csp/sdf/EnsPortal.MessageViewer.zen?SOURCEORTARGET=HL7%20In) in the production.
* Access http://localhost:8080 to have a glance at the DataPipeUI
* After processing data, run some SQL queries again.

You can also copy all files using:
```
cd data
cp hl7files/*.hl7 hl7in
```

<img src="img/hl7-ingestion-datapipe.gif" width="1024" />

## DataPipe Model
DataPipe allows you to define an interoperability model with the properties that you need, and then decide how are you going to normalize and validate it. You have to implement a few methods.

<img src="img/datapipe-abstract-model.png" width="200" />

In this case, we are using [R01Model.cls](src/sdf/connectors/interop/datapipe/model/R01Model.cls):
* It defines the properties we need for processing incoming ORU^R01 HL7 messages with observations.
* Implements `Serialize` and `Deserialize` methods to serialize and deserialize using JSON format.
* To `Normalize`, it calls [R01Normalize](http://localhost:52773/csp/sdf/EnsPortal.DTLEditor.zen?DT=sdf.connectors.interop.datapipe.dt.R01Normalize.dtl) data transformation.
* To `Validate`, implements some checks on the incoming data.
* Finally, in `RunOperation` implements what are we going to do with the ingested data. In this example it is storing data in `sdf.data.*` classes.

## DataPipe Production
* The [production](http://localhost:52773/csp/sdf/EnsPortal.ProductionConfig.zen?PRODUCTION=sdf.connectors.interop.Production) that is ingesting data, have some elements you should review:
* `HL7 In` - built-in HL7 file Business Service that reads HL7 files from a directory.
* [HL7 Ingestion](http://localhost:52773/csp/sdf/EnsPortal.BPLEditor.zen?BP=sdf.connectors.interop.datapipe.bp.HL7Ingestion.bpl) - Business Process that: 
  * Extract attributes (metadata) from incoming HL7 message using [R01ToInboxAttributes](http://localhost:52773/csp/sdf/EnsPortal.DTLEditor.zen?DT=sdf.connectors.interop.datapipe.dt.R01ToInboxAttributes.dtl) data transform.
  * Converts incoming HL7 message into [sdf.connectors.interop.datapipe.model.R01Model.cls](src/sdf/connectors/interop/datapipe/model/R01Model.cls) using [R01ToModel](http://localhost:52773/csp/sdf/EnsPortal.DTLEditor.zen?DT=sdf.connectors.interop.datapipe.dt.R01ToModel.dtl) data transform.
* `HL7 Staging` is a DataPipe business process (`DataPipe.Staging.BP.StagingManager`) that handles the normalization and validation of your DataPipe model.
* `HL7 Oper` is another DataPipe business process (`DataPipe.Oper.BP.OperManager`) that handles running your DataPipe model operation.

# Services

Let's create a REST service to interact with your `sdf.data.*` classes. But first, we can start by working with JSON.

## JSON

### %JSON.Adaptor
Your `sdf.data.*` classes already extends from [%JSON.Adaptor](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GJSON_adaptor). It provides some nice features for importing and exporting your objects to and from JSON.

Open a [WebTerminal](http://localhost:52773/terminal/) session and try the following:

Open an object and export to JSON:

```objectscript
    // open an object from a persistent class
    set patient = ##class(sdf.data.Patient).%OpenId(1)
    // directly, export to json to current device
    do patient.%JSONExport()
```

Now, let's try to format the JSON for our object:

```objectscript
    // export patient object to a json string
    do patient.%JSONExportToString(.json)
    // instantiate a json formatter
    set formatter = ##class(%JSON.Formatter).%New()
    do formatter.FormatToString(json, .formattedJson)
    // print formatted json
    write formattedJson
```

In your [sdf.data.Patient](src/sdf/data/Patient.cls) class, change the `%JSONREFERENCE` attribute from `ID` to `OBJECT` or viceversa and try again the following:

```objectscript
    // delete previous in-memory object definition
    kill patient
    // re-open object (so it can load your change on %JSONREFERENCE)
    set patient = ##class(sdf.data.Patient).%OpenId(1)
    // export to a formatted json string
    do patient.%JSONExportToString(.json)
    do formatter.FormatToString(json, .formattedJson)
    // print your json string
    write formattedJson
```

Can you tell the difference between using `ID` or `OBJECT`?

⚠️ **Important!** Before going on, be sure your [sdf.data.Patient](src/sdf/data/Patient.cls) class has `(%JSONREFERENCE = "ID")` defined.

[%JSON.Adaptor](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GJSON_adaptor) has a lot of nice features that allows you to export and import and customize those behaviours. We'll use them in the REST service we will implement.

`%JSON.Adaptor` is a nice approach if you have already defined classes that you want to serialize or deserialize to JSON format.

### %DynamicObjects

[%DynamicObjects](https://docs.intersystems.com/irisforhealth20222/csp/docbook/DocBook.UI.Page.cls?KEY=GJSON_create) allows you to work with JSON structures without having a previous definition (dynamically).

In your [WebTerminal](http://localhost:52773/terminal/) session try the following:

```objectscript
    set dynamicObject = {"prop1":"a string value"}
    write dynamicObject.prop1

    set dynamicArray = [[1,2,3],{"A":33,"a":"lower case"},1.23456789012345678901234,true,false,null,0,1,""]
    write dynamicArray.%ToJSON()
```

Have a look at the documentation section [Using JSON in ObjectScript](https://docs.intersystems.com/irisforhealth20222/csp/docbook/DocBook.UI.Page.cls?KEY=GJSON_intro) to have an overview of all the options you have available with `%JSON.Adaptor` or `%DynamicObjects`.


## REST Service

There are different ways of implement REST services in InterSystems IRIS. We will implement a `%CSP.REST` service. Don't forget to check the documentation section [Introduction to Creating REST Services](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GREST_intro) to have a full view.

Open [sdf.connectors.api.DataEndpoint](src/sdf/connectors/api/DataEndpoint.cls). This will be our service for accesing some of our `sdf.data.*` classes.

Review the different methods that are implemeted and try to figure out what are they doing.

REST services needs a web application that forwards HTTP requests to them, in this case we have the [/sdf/api](http://localhost:52773/csp/sys/sec/%25CSP.UI.Portal.Applications.Web.zen?PID=%2Fsdf%2Fapi) web application.

Also, in [iris.script](iris.script) you will find how this web application is imported during the container image build for the environment.

Finally, try your service using **Postman**. Import the [workshop-smart-data-fabric.postman_collection.json](workshop-smart-data-fabric.postman_collection.json) included in the repository and try the different requests:

<img src="img/rest-postman.gif" witdth="1024"/>

## Embedded Python
Embedded Python allows you to use Python to program InterSystems IRIS applications. You can even mix ObjectScript methods and Python methods and refer to objects created in either language! And of course you could use any Python libraries on your implementation. Check the documentation section [Using Embedded Python](https://docs.intersystems.com/irisforhealth20222/csp/docbook/DocBook.UI.Page.cls?KEY=AEPYTHON) to have a full view on this topic.

We will use some Python libraries we must install. First, you need to connect to container bash:
```bash
docker compose exec iris bash
```

Then install the libraries we will use:
```bash
pip3 install --target /usr/irissys/mgr/python/ pandas openpyxl
```

We are going to use Embedded Python to implement in our REST service an operation that will return an Excel file with the observations for an specific patient. We will take advantage of [openpyxl](https://openpyxl.readthedocs.io/en/stable/) Python library to create Excel files:
* REST service will handle `/patient/:id/observations/xls` requests to return an Excel file.
* [sdf.connectors.api.DataEndpoint](src/sdf/connectors/api/DataEndpoint.cls):`GetPatientObservationsExcel` method will run a SQL query, create a result set and convert it to Excel.
* Actual resultset to Excel conversion will be run in [sdf.Utils](src/sdf/Utils.cls):`ResultSetToXls` which is an Embedded Python classmethod that takes advantage of openpyxl](https://openpyxl.readthedocs.io/en/stable/) library.

You can test it accessing to http://localhost:52773/sdf/api/patient/2/observations/xls in your browser.

# Interoperability

We are going to create a Telegram bot and use it to send some notifications about our Smart Data Fabric.

## Telegram bot setup
* Create a Telegram bot using [BotFather](https://t.me/botfather) bot.
```
/newbot
```
Write down your Telegram Bot token.

* Open a new Telegram chat with your brand new Telegram bot. Write some dummy messages.
* Usually, you will process incoming messages to your bot using a WebHook or the getUpdates Telegram API. In this example, we will only focus on sending messages.
* You will need a **chat id** and your **token** to send messages.
* Grab your **chat id** by accesing [https://api.telegram.org/bot<your_token>/getUpdates](https://api.telegram.org/bot<your_token>/getUpdates). You should get a JSON response from Telegram. Look for something like:
```
...
"chat":{"id":<your_chatId>
...
```

## Business operation settings
* Go to [IRIS > Interoperability > Configure > Credentials](http://localhost:52773/csp/sdf/EnsPortal.Credentials.zen?$NAMESPACE=SDF&$NAMESPACE=SDF&) and create a `TelegramBotToken` Credentials with your token as password.
* Go to our [Interoperability Production](http://localhost:52773/csp/sdf/EnsPortal.ProductionConfig.zen?PRODUCTION=sdf.connectors.interop.Production&$NAMESPACE=SDF), select `TelegramSendMessage` operation and set the following:
  * TelegramCredentials: `TelegramBotToken`
  * DefaultTelegramChatId: `your chatId`

You can now test your Telegram Business Operation:

<img src="img/telegram-bo-test.gif" width="1500" />

## Calling your Business operation

### Ingestion
You can call your Telegram business operation from the ingestion layer using your Data Pipe model, try to add the following in [R01Model](src/sdf/connectors/interop/datapipe/model/R01Model.cls):

```objectscript
    $$$AddLog(log, "Transaction Commited")

    // you can send messages to other production components (while you are not on an open transaction)
    if $isobject(bOperation) {
        set req = ##class(sdf.connectors.interop.msg.TelegramMsgReq).%New()
        set req.text = "Patient ("_..PatientId_") ingested! 🌡️ "_$number(..ObxValues.GetAt("BodyTemp"),2)_" "_..ObxUnits.GetAt("BodyTemp")
        $$$ThrowOnError(bOperation.SendRequestAsync("TelegramSendMessage", req))
    }
```

### Services
You can also call interoperability components from your REST service context.

Let's call the Telegram business operation from the REST service:
* Service will handle requests to `/summary` to send a summary of the sdf.
* This will be implemented in [DataEndpoint](sdf.connectors.api.DataEndpoint):`GetSummary`.
* In the method, we will call interoperability components. For that you need to start your call instatiating a Business Service that will init the interoperability context.
* We will instantiate [TelegramFromService](sdf.connectors.interop.bs.TelegramFromService) business service. It will simply send a message to our Telegram business operation.

# Enabling FHIR using FHIR Façade Architecture

HL7 FHIR (Fast Healthcare Interoperability Resources) has become the top standard for the exchange of patient data across healthcare systems.

However, not all applications can be completely re-written to exchange data using the FHIR standard, and facilities may not be able to deploy a *full FHIR repository*.

You can use InterSystems IRIS For Health to to create an architecture that acts as a façade for a FHIR repository, allowing you to avoid complete rework while reaping the benefits of using FHIR data in your existing applications.

You can find more information in [FHIR Façade Architecture Overview](https://learning.intersystems.com/course/view.php?id=2137).

Let's say that you want to implement an architecture that enables FHIR for our classes in `sdf.data.*` package. 

You will now implement a FHIR Façade.

## Create a FHIR Server
You will now create a FHIR Server and use your own InteractionsStrategy that implements a FHIR Façade on top of your `sdf.data.*` package:

Create a FHIR server in *Health > SDF > FHIR Configuration > Server Configuration > Add Endpoint*
* Core FHIR package: `hl7.fhir.r4.core@4.0.1`
* URL: `/csp/healthshare/sdf/fhir/r4`
* Interactions Strategy Class: `sdf.fhirserver.InteractionsStrategy`

Now, edit the FHIR endpoint you have just created:
* Enable New Service Instance. This is useful in case you want to change InteractionsStrategy class during development and test the new behaviour immediately.

## FHIR Façade implementation
In this case these are the main involved classes:
* [sdf.fhirserver.InteractionsStrategy](src/sdf/fhirserver/InteractionsStrategy.cls), [sdf.fhirserver.Interactions](src/sdf/fhirserver/Interactions.cls) and [sdf.fhirserver.RepoManager](src/sdf/fhirserver/RepoManager.cls) - these are the main classes you should implement when writing you FHIR Server Interactions strategy. You can find more information in [Customizing a FHIR Server](https://docs.intersystems.com/irisforhealthlatest/csp/docbook/DocBook.UI.Page.cls?KEY=HXFHIR_server_customize_arch).
* [sdf.fhirserver.FHIRFacade](src/sdf/fhirserver/FHIRFacade.cls) - common class we have implemented for this example. It includes some methods that must be implemented in façade classes such as how to export your data as FHIR resource or how to perform searchs.
* [sdf.data.Patient](src/sdf/data/Patient.cls) and [sdf.data.Observation](src/sdf/data/Observation.cls) - your data classes will now implement *FHIRFaçade* methods.

## Try it out
Using the included [Postman collection](workshop-smart-data-fabric.postman_collection.json), try some requests that are already prepared:
* `metadata`: retrieve your FHIR Façade Capability Statement
* `Get Patient`: retrieve a particular patient as a FHIR resource
* `Get Patients. Female. Paginated`: search female patients and retrieve a paginated bundle.

## Adding OAuth to your FHIR Server
* You will use the webserver container included in the workshop, as it provides you a webserver (Apache) + WebGateway connection to IRIS using HTTPS. This is required for OAuth2.
* You can test it by accesing the IRIS Management Portal using this URL: https://webserver/iris/csp/sys/UtilHome.csp
* To use FHIR and OAuth2 you will use SMART On FHIR Scopes, you can find more information [here](https://hl7.org/fhir/smart-app-launch/1.0.0/scopes-and-launch-context/index.html).

You can also find more information about IRIS and OAuth2 in [workshop-iris-oauth2](https://openexchange.intersystems.com/package/workshop-iris-oauth2).

### Create OAuth2 Server
IRIS will act as your OAuth Authorization server. You can create a it in *System Administration > Security > OAuth 2.0 > Server*

Or you can simply type this command that will create the OAuth Authorization server for you:
```
zn "SDF"
do ##class(sdf.Utils).CreateOAuth2Server()
```

### Create OAuth2 Resource Server
Next, create the OAuth2 Resource server that will be used in your FHIR Server.

Go to *System Administration > Security > OAuth 2.0 > Client > Create Server Description*
* Issuer endpoint: `https://webserver/iris/oauth2`
* SSL/TLS configuration: `ssl`
* Discover and Save

Go to *System Administration > Security > OAuth 2.0 > Client > Client Configurations > Create Client Configuration*:
* Application name: `fhirserver-resserver`
* Client name: `fhirserver oauth resource server`
* Client type: `Resource server`
* SSL/TLS configuration: `ssl`
* Dynamic Registration and Save

### Create OAuth2 Client configuration
Next, add a new client (with a ClientId and a Secret) that will be used while testing your FHIR Server + OAuth from Postman.

* Go to *System Administration > Security > OAuth 2.0 > Server > Client Descriptions*
* **Important!** write down your ClientId and Secret. You will need them in Postman to try it out.

<img src="img/postman-oauth-client.png" width="700" />
 

### Update your FHIR Server to use your OAuth2 configuration
Now, go back and edit your FHIR Server endpoint in *Health > SDF > FHIR Configuration > Server Configuration > Edit Endpoint*

Update the following:
* OAuth2 Client Name: `fhirserver-resserver`

### Try it using OAuth2!
* Open the included Postman project
* Update `oauth-clientid` and `oauth-clientsecret` Postman variables to use your ClientID and Secret.
* Test the included FHIR OAuth requests by first requesting a token and then sending the request.


# Analytics

<img src="img/iris-analytics-platform.png" width="1024" />

There multiple ways in which you can leverage [analytics & data science](https://docs.intersystems.com/irisforhealthlatest/csp/docbook/DocBook.UI.Page.cls?KEY=PAGE_data_science) using InterSystems IRIS:
- IRIS Business Intelligence - Allows you to embed business intelligence into your applications. You can have a first look at it in [workshop-iris-bi-intro](https://github.com/intersystems-ib/workshop-iris-bi-intro)
- Adaptive Analytics - an optional extension that provides a business-oriented, virtual data model layer between InterSystems IRIS and popular Business Intelligence (BI) and Artificial Intelligence (AI) client tools. You can checkout this Spanish Webinar [Self-Service Analytics y Reporting](https://comunidadintersystems.com/webinar-self-service-analytics-y-reporting).

We will focus on IRIS BI on our first example.

## BI. Defining a Cube
Open [Management Portal > Analytics > SDF > Architect > Open Observations Cube](http://localhost:52773/csp/sdf/_DeepSee.UI.Architect.zen?$NAMESPACE=SDF&CUBE=ObxCube.cube) and go through the different dimensions and measures defined for a cube based on the observations persistent class.

These dimensions and measures define what kind of analysis can be done using this cube.

Click on **Build** to build the cube based on the data you have loaded previously.

<img src="img/bi-architect.png" width="1024" />

## BI. Analyzer
Then, open [Management Portal > Analytics > SDF > Analyzer > Open Observations Cube](http://localhost:52773/csp/sdf/_DeepSee.UI.Analyzer.zen?$NAMESPACE=SDF&$NAMESPACE=SDF&) and try different combinations for rows & columns on your analysis pivot table.

You can also open a pre-defined pivot. In your VS Code Import & Compile [AvgObservationsByAge.pivot.dfi](src/sdf/AvgObservationsByAge.pivot.dfi).
<img src="img/bi-analyzer.gif" width="1024" />

## BI. User portal
Finally, you can create dashboards and build widgets based on your analysis pivot tables. In your VS code Import & Compile [AvgObservationsByCode.dashboard.dfi](src/sdf/AvgObservationsByCode.dashboard.dfi).

Then, open [Management Portal > Analytics > SDF > User Portal > Open Avg Values by Sex, Age Dashboard](http://localhost:52773/csp/sdf/_DeepSee.UserPortal.Home.zen)

<img src="img/bi-user-portal.gif" width="1024" />


## BI. DSW
In [Open Exchange](https://openexchange.intersystems.com) you can find awesome applicatiosn like [DSW](https://openexchange.intersystems.com/package/DeepSeeWeb) that enables a whole new great looking UI for your IRIS BI. 

You can checkout in your example accessing http://localhost:52773/dsw/index.html#/SDF 

<img src="img/bi-dsw.gif" width="1024" />


## Machine Learning. IntegratedML
Again, there are different ways you can add [Machine Learning features on your InterSystems IRIS Applications](https://docs.intersystems.com/irisforhealth20222/csp/docbook/DocBook.UI.Page.cls?KEY=GIML_Intro):
* IntegratedML - is an InterSystems IRIS features that allows you to leverage automated machine learning functions directly from SQL.
* [PMML](https://docs.intersystems.com/irisforhealth20222/csp/docbook/DocBook.UI.Page.cls?KEY=APMML) - Predictive Modeling Markup Language is an XML-based standard that expresses analytical models. You can express a model using PMML and deploy it in InterSystems IRIS.
* Python libraries - and of course, taking advantage of Embedded Python, you can use Python libraries such as `pandas`, `scikit-learn`, `tensorflow`, etc directly with your IRIS data to implement your ML models.

We will focus on a simple example of [IntegratedML](https://docs.intersystems.com/irisforhealth20222/csp/docbook/Doc.View.cls?KEY=GIML_Intro).

<img src="img/automl.png" width="800" />

We are still using a dataset inspired on [Maternal Health Risk Data](https://www.kaggle.com/datasets/csafrit2/maternal-health-risk-data) dataset from Kaggle. 

"Inspired" in this particular case means that we won't have all the data available, so the accuracy of our ML model could be better.

In any case, if you are interested on using the whole dataset check out [workshop-integratedml-intro](https://github.com/intersystems-ib/workshop-integratedml-intro).

Now, in our example check the following:
* [MaternalRiskTrain.cls](src/sdf/data/MaternalRiskTrain.cls) - a view that we will use as our training data.
* [MaternalRiskTest.cls](src/sdf/data/MaternalRiskTest.cls) - a view that we will use as our test data for validation.

Go to [Management Portal > Explorer > SQL > SDF](http://localhost:52773/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=SDF) and run the following:

Create a model for predicting the `RiskLevel` column based on your training data:

```sql
CREATE MODEL MaternalModel PREDICTING (RiskLevel) FROM sdf_data.MaternalRiskTrain
```

Train your model using your training data:

```sql
TRAIN MODEL MaternalModel
```

Now, validate your model using your test data:

```sql
VALIDATE MODEL MaternalModel FROM sdf_data.MaternalRiskTest
```

You can check the validation metrics for your model:

```sql
SELECT * FROM INFORMATION_SCHEMA.ML_VALIDATION_METRICS
```

And finally, you can use your model to get predictions:

```sql
SELECT *, PREDICT(MaternalModel) AS PredictedRisk FROM sdf_data.MaternalRiskTest
```


## Jupyter Notebooks
In [docker-compose.yml](docker-compose.yml) has been added a jupyter notebook service so we can connect to IRIS using [IRIS Native SDK for Python](https://docs.intersystems.com/irisforhealth20222/csp/docbook/DocBook.UI.Page.cls?KEY=BPYNAT).

Try the following:
* Open your Jupyter Notebook instance in http://localhost:8888
* Open [IRISPython.ipynb](jupyter/notebooks/IRISPython.ipynb)

Try it! Think about all the available Python ML libraries you could use to analyze your IRIS data from a pure Python context. You can run queries or directly call your IRIS objects methods.

<img src="img/jupyter-iris-native-python.gif" width="1024" />


# Appendix. Generating data
During the workshop you have been working with already created HL7 files inspired on [Maternal Health Risk Data](https://www.kaggle.com/datasets/csafrit2/maternal-health-risk-data) dataset from Kaggle.

Here is how these HL7 files have been created:

Load train data into a temporary table in IRIS:
```objectscript
do ##class(community.csvgen).Generate("/app/data/maternalRisk/maternal_health_risk.csv",",","temp.MaternalHealthRisk")
```

Then use a simple tool to generate HL7 files:
```objectscript
do ##class(sdf.tools.HL7Generator).GenerateFilesHL7()
```

Your files will be generated in `data/maternalRisk/hl7gen`.
