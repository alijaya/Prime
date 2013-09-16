# Prime

http://prime.vc

A collection of libraries to make data-driven GUI development easier and more fun.

Watch our [Presentation] (http://www.youtube.com/watch?v=UAT9RBb7wcU) presentation (with [slides here](http://wwx-2013.prime.vc)) at WWX 2013 for an introduction.

***

#### Stable, cross-platform, high-quality libraries:

<table>
 <thead><td colspan="2">Library</td> <td>Planned targets</td> <td>Currently tested targets</td></thead>
 <tr>  <td><b>core</b></td>      <td>Core interfaces and generic utilities.</td>
                           <td>all</td>  <td>all</td> </tr>
 <tr>  <td><b>signals</b></td>   <td>Strictly typed, lightweight, memory and cpu optimized signal (event) library.</td>
                           <td>all</td>  <td>swf: `prime.*`, others: `prime.signal.*`</td> </tr>
 <tr>  <td><b>bindable</b></td>  <td>Data-binding built on signals.</td>
                           <td>all</td>  <td>all</td> </tr>
 <tr>  <td><b>i18n</b></td>      <td>YAML based compile-time internalization library built on Franco's <a href="http://github.com/fponticelli/thx">thx</a> localization helpers and Bindable.</td>
                           <td>all</td>  <td>SWF 9+</td> </tr>
 <tr>  <td><b>mvc</b></td>       <td>Strictly typed Model-View-Controller for stateful GUI applications.</td>
                           <td>all</td>  <td>all</td> </tr>
 <tr>  <td><b>fsm</b></td>       <td>Finite State Machine, with state change events built on signals.</td>
                           <td>all</td>  <td>all</td> </tr>
 <tr>  <td><b>layout</b></td>    <td>2D box-model layouting for anything.</td>
                           <td>all</td>  <td>SWF 9+</td> </tr>
</table>


#### Stable libraries, optimized for Flash:

<table>
 <thead><td colspan="2">Library</td> <td>Planned targets</td> <td>Currently tested targets</td></thead>
 <tr>  <td><b>display</b></td>    <td>Flash Display-list as a datastructure with signals and change events.</td>
                            <td>SWF, NME 4, OpenFL</td>  <td>SWF, NME 3.5.5</td> </tr>
 <tr>  <td><b>components</b></td> <td>GUI components seperated into: logic, skinning and styling.</td>
                            <td>SWF, NME 4, OpenFL</td>  <td>SWF, NME 3.5.5 (except those using TextFields)</td> </tr>
 <tr>  <td><b>media</b></td>      <td>Video and Audio player stream state handling and components.</td>
                            <td>SWF, OpenFL?</td> <td>SWF</td> </tr>
</table>


#### Alpha libraries:

<table>
 <thead><td colspan="2">Library</td> <td>Planned targets</td> <td>Currently tested targets</td></thead>
 <tr>  <td><b>data</b></td>       <td>Generic data handling. ValueObjects, CSV parser and other utils.</td>
                            <td>all</td>  <td>SWF, should work on more.</td> </tr>
 <tr>  <td><b>perceptor</b></td>  <td>See what's happening inside your Prime application. Firebug-like inspector.</td>
                            <td>Standalone app</td>  <td>Embeddable in SWF.</td> </tr>
</table>


# Getting started

Each library has it's own README which gives you more detail what they are about.

Checkout the example project here: https://github.com/touch/Prime-examples.
We've also built a [sample TODO-list application](http://github.com/touch/Prime-Todo) to see most of our libraries in action.



# Contributors

Any help, comments and patches are much appreciated.


* [Ruben](https://github.com/freakinruben)
* [Danny](https://github.com/vizanto)
* [EzeQL](https://github.com/ezeql)
* [Andrew](https://github.com/apahuru)
