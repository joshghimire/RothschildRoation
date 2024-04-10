
# You can also put your plugins in ~/.phy/plugins/.

from phy import IPlugin

# Plugin example:
#
# class MyPlugin(IPlugin):
#     def attach_to_cli(self, cli):
#         # you can create phy subcommands here with click
#         pass

c = get_config()
c.Plugins.dirs = [r'/home/ukaya/.phy/plugins',r'/data/Toolboxes/phyPlugins/plugins']
c.TemplateGUI.plugins= ['Recluster','ExampleNspikesViewsPlugin','ExampleClusterViewStylingPlugin','ExampleNspikesViewsPlugin','ExampleCustomSplitPlugin'] #names of python classes that defines different plugins 