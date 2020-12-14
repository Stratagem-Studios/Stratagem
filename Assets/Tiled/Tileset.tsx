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
  <image width="200" height="400" source="oil.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="name" value="iron"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="200" height="400" source="iron.png"/>
 </tile>
 <!-- Industrial tiles -->
 <tile id="30">
  <properties>
      <property name="CREDITS" value="300"/>
      <property name="METAL" value="10"/>
      <property name="CONSUMES METAL" value="2"/>
    <property name="onTile" value="[sand, grass, iron, oil]"/>
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
      <property name="onTile" value="[iron]"/>
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
  <property name="onTile" value="[sand, grass, iron, oil]"/>
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
   <property name="onTile" value="[sand, grass, iron, oil]"/>
   <property name="name" value="Simple road"/>
   <property name="type" value="road"/>
   <property name="description" value="A basic road"/>
  </properties>
  <image width="200" height="400" source="road.png"/>
 </tile>
 <!-- Military tiles -->
 <tile id="120">
  <properties>
   <property name="CREDITS" value="100"/>
   <property name="METAL" value="20"/>
   <property name="onTile" value="[sand, grass, iron, oil]"/>
   <property name="name" value="Robot Factory MK I"/>
   <property name="type" value="military"/>
   <property name="description" value="Produces cheap robots for the military"/>
  </properties>
  <image width="200" height="400" source="robot factory MKI.png"/>
 </tile>
</tileset>
