# MinimalVisualListener
Pure AS3 visual listener for FlexUnit based on MinimalComps

Usage:
------
```actionscript
core = new FlexUnitCore();
var visualListener:MinimalVisualListener = new MinimalVisualListener( stage.stageWidth, stage.stageHeight );
addChild( visualListener );
core.addListener( visualListener );
core.run( TestSuite );
```
