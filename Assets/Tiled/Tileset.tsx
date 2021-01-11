<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.4" tiledversion="1.4.3" name="Tileset" tilewidth="200" tileheight="400" tilecount="6" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <!-- Ground tiles -->
 <tile id="0">
  <properties>
   <property name="name" value="grass"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="200" height="400" source="grass.png"/>
 </tile>
 <tile id="1">
  <properties>
   <property name="name" value="sand"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="200" height="400" source="sand.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="name" value="water"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="200" height="400" source="water.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="name" value="oil"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="200" height="400" source="oil tile.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="name" value="iron"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="200" height="400" source="iron tile.png"/>
 </tile>
 <!-- Industrial tiles -->
 <tile id="30">
  <properties>
      <property name="CREDITS" value="300"/>
      <property name="METAL" value="10"/>
      <property name="CONSUMES METAL" value="2"/>
    <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="Simple building"/>
   <property name="type" value="industrial"/>
   <property name="description" value="Consumes iron"/>
  </properties>
  <image width="200" height="400" source="building industrial.png"/>
 </tile>
 <tile id="31">
  <properties>
      <property name="CREDITS" value="300"/>
      <property name="METAL" value="10"/>
      <property name="PRODUCES METAL" value="3"/>
      <property name="onTileName" value="[iron]"/>
   <property name="name" value="Iron miner"/>
   <property name="type" value="industrial"/>
   <property name="description" value="Place on iron ore to mine it"/>
  </properties>
  <image width="200" height="400" source="iron miner.png"/>
 </tile>
 <!-- Residential tiles -->
 <tile id="60">
  <properties>
  <property name="CREDITS" value="100"/>
  <property name="METAL" value="10"/>
  <property name="onTileName" value="[grass, iron, oil]"/>
  <property name="popRate" value="0.001"/>
  <property name="popCap" value="5000"/>
   <property name="name" value="Simple residential"/>
   <property name="type" value="residential"/>
   <property name="description" value="A basic residential building"/>
  </properties>
  <image width="200" height="400" source="building residential.png"/>
 </tile>
 <!-- Road tiles -->
 <tile id="90">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0000"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0000.png"/>
 </tile>
 <tile id="91">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1000"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1000.png"/>
 </tile>
 <tile id="92">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0100"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0100.png"/>
 </tile>
 <tile id="93">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0010"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0010.png"/>
 </tile>
 <tile id="94">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0001"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0001.png"/>
 </tile>
 <tile id="95">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1010"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1010.png"/>
 </tile>
 <tile id="96">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0101"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0101.png"/>
 </tile>
 <tile id="97">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1100"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1100.png"/>
 </tile>
 <tile id="98">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0110"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0110.png"/>
 </tile>
 <tile id="99">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0011"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0011.png"/>
 </tile>
 <tile id="100">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1001"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1001.png"/>
 </tile>
 <tile id="101">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1110"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1110.png"/>
 </tile>
 <tile id="102">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile0111"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile0111.png"/>
 </tile>
 <tile id="103">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1011"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1011.png"/>
 </tile>
 <tile id="104">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1101"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1101.png"/>
 </tile>
 <tile id="105">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="roadtile1111"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="roadtile1111.png"/>
 </tile>
 <!-- Military tiles -->
 <tile id="120">
  <properties>
   <property name="CREDITS" value="100"/>
   <property name="METAL" value="20"/>
   <property name="onTileName" value="[grass, iron, oil]"/>
   <property name="name" value="Robot Factory MK I"/>
   <property name="type" value="military"/>
   <property name="description" value="Produces cheap robots for the military"/>
  </properties>
  <image width="200" height="400" source="robot factory MKI.png"/>
 </tile>
</tileset>
