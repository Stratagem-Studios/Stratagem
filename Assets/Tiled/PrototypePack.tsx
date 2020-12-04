<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.4" tiledversion="1.4.3" name="PrototypePack" tilewidth="256" tileheight="512" tilecount="6" columns="0">
 <grid orientation="orthogonal" width="1" height="1"/>
 <!-- Ground tiles -->
 <tile id="0">
  <properties>
   <property name="name" value="grass"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="256" height="512" source="block_grass.png"/>
 </tile>
 <tile id="1">
  <properties>
   <property name="name" value="sand"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="256" height="512" source="block_sand.png"/>
 </tile>
 <tile id="2">
  <properties>
   <property name="name" value="water"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="256" height="512" source="block_water.png"/>
 </tile>
 <tile id="3">
  <properties>
   <property name="name" value="oil"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="256" height="512" source="oil.png"/>
 </tile>
 <tile id="4">
  <properties>
   <property name="name" value="iron"/>
   <property name="type" value="ground"/>
  </properties>
  <image width="256" height="512" source="iron.png"/>
 </tile>
 <!-- Industrial tiles -->
 <tile id="30">
  <properties>
      <property name="CREDITS" value="300"/>
      <property name="METAL" value="10"/>
      <property name="CONSUMES METAL" value="2"/>
   <property name="name" value="simple building"/>
   <property name="type" value="industrial"/>
  </properties>
  <image width="256" height="512" source="building industrial.png"/>
 </tile>
 <tile id="31">
  <properties>
      <property name="CREDITS" value="300"/>
      <property name="METAL" value="10"/>
      <property name="PRODUCES METAL" value="3"/>
   <property name="restriction" value="iron"/>
   <property name="name" value="iron miner"/>
   <property name="type" value="industrial"/>
  </properties>
  <image width="256" height="512" source="iron miner.png"/>
 </tile>
 <!-- Residential tiles -->
 <tile id="60">
  <properties>
  <property name="CREDITS" value="100"/>
  <property name="METAL" value="10"/>
  <property name="popRate" value="0.001"/>
  <property name="popCap" value="5000"/>
   <property name="name" value="simple residential"/>
   <property name="type" value="residential"/>
  </properties>
  <image width="256" height="512" source="building residential.png"/>
 </tile>
 <!-- Road tiles -->
 <tile id="90">
  <properties>
   <property name="CREDITS" value="50"/>
   <property name="METAL" value="5"/>
   <property name="name" value="simple road"/>
   <property name="type" value="road"/>
  </properties>
  <image width="256" height="512" source="road.png"/>
 </tile>
</tileset>
