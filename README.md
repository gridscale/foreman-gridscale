# ForemanGridscale

*Plugin to enable management of gridscale instances from within foreman*

## Installation

1. Extract the supplied archive on the server which has Foreman installed on it. Make sure to do this in a directory which can be accessed by the user running Foreman.

2. In the foreman/bundler.d directory (usually found in /usr/share/), create or edit the file Gemfile.local.rb and add the following lines to it:

    ```ruby
    gem 'fog-gridscale', :path => 'path to fog-gridscale directory'
    gem 'foreman_gridscale', :path => 'path to foreman-gridscale directory'
    ```

3. Next run the following command: 

    ```
    $ cd /usr/share/foreman && sudo -u foreman /usr/bin/foreman-ruby /usr/bin/bundle install
    ```

4. Then restart Foreman with:
    ```
    $ touch /usr/share/foreman/tmp/restart.txt
    ```

See [How_to_Install_a_Plugin](http://projects.theforeman.org/projects/foreman/wiki/How_to_Install_a_Plugin)
for how to install Foreman plugins


## How to Use
### Configuration

Go to **Infrastructure > Compute Resources** and click on "New Compute Resource".

Choose the **gridscale** as the provider, and fill in all the fields. You need an your API token and user uuid with read and write access, which can be created at the [gridscale API section](https://my.gridscale.io/APIs/). 

That's it. You're now ready to create and manage servers in your new gridscale  compute resource.

You should see something like this in the [Compute Resource](https://theforeman.org/manuals/1.19/index.html#5.2ComputeResources) page:

### Host Creation
1. Go to host > create host and choose gridscale as a deployment target. the virtual machine tab with all of the parameter field to create a server will appear.
2. If you already set up your compute profile, you can choose it and it will automatically set up the virtual machine parameter. you can also overwrite them
3. On the virtual machine tab, Fill in the fields with a desire number cores, memory, and capacity of the storage. You can also attached the gridscale template or your private template to your storage.
4. fill the operating system tab 
5. In the interface tab, click the edit button in actions column, and pick gridscale network interface you wish to connect your machine. you can also add multiple network interfaces by clicking the add interface button below the interface table. click OK when you finish
6. Click submit button to finish the Host creation

### Compute Profile
1. Click infrastructure > compute profile 
2. Click create compute profile button on the top right side of the screen
3. Fill the name field, and click the submit button
4. Click on the compute resource link that you want to associate your compute profile.
5. Fill up the compute profile attributes and click the submit button
6. Now you are ready to use your compute profile

### Host Management
Click Host > All Host. and you will be able to see all of the hosts that created through foreman in the tables. In a power column displays the power status of the server. The host’s details can be seen by clicking the link in its name.
    
**Powering off/on**
1. Choose the host by checking the box on the first column of the table (you can select all of the hosts by checking the box on the header)
2. Click the action button, and choose change power state 
3. Select the desired power state on the dropdown power list
4. Click submit

**Delete Host**
1. Choose the host by checking the box on the first column on of the table (you can select all of the host by checking the box on the header)
2. Click the action button, and choose delete host (you can also delete it singularly by clicking the dropdown list in the actions column)
3. Click submit and confirm the action


###Host management through the compute resource page
Go to Infrastructure > Compute resource and select the compute resource for gridscale. go to virtual machine tab. The virtual machine tab displays all of the server in the gridscale panel.

##Known Issues
* When creating a host, multiple network interfaces can be set to bootable. The gridscale platform does not support this, which is why only one of the interfaces will actually be set to bootable if this is the case.
* When creating a compute profile, the chosen network interface configuration is not saved.
* The Virtual Machines overview of a compute resource can take a long time to load.
* The data shown in the VM tab of a host is not complete. More input about which information is useful is needed.
* Opening the console of a host in Foreman has not been implemented, but a link to gridscale is supplied.
* Acpi power off fails to shut down a system which did not boot.
* MAC, IP4 and IP6 information are in VM tab, not in Interface.

