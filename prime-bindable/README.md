# Prime Bindable 

Easy and powerful data binding for Haxe.

Parameterized data structures, collections and iterators. 

[Bindable Example](http://prime.vc/api/prime-bindable/types/prime/bindable/Bindable.html)

You can trigger another bindable to update by doing:
```js
			var a = new Bindable(5);
			var b = new Bindable(6);
			a.bind(b);		//a will be 6 now
			b.value = 8;	//a will be 8 now
```
You can also create a two way binding by doing:
```js
			a.pair(b);
```
Which is effictively the same as doing:
```js
			a.bind(b);
			b.bind(a);  	//will not create an infinte loop ;-)
```

You can trigger a method when the property is changed:
```js
			using prime.utils.Bind;

			function updateLabel (newLabel:String) : Void {
				textField.text = newLabel;
			}

			var a = new Bindable  ("aap");
			updateLabel.on( a.change, this );

			a.value = "2 apen";	//textField.text will also be changed now
```
The 'change' event will be dispatched after 'this.value' changes.

Further documentation available [here](http://prime.vc/api/prime-bindable/index.html).

# Installation

Prime-bindable is available for Haxe 3 through the latest version of Haxelib (major version 3 or higher).

	haxelib install prime-bindable
