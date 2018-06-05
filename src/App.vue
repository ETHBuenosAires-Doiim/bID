<template>
  <v-app>
    <v-navigation-drawer app>
      <img width='100px' src="./assets/logo.png">
      <v-list dense>
        <v-list-tile router :to="'/signup'" > 
        <v-list-tile-action>
          <v-icon color="light-green">home</v-icon>
        </v-list-tile-action>
        <v-list-tile-content>
          <v-list-tile-title color="light-green">Sign Up</v-list-tile-title>
        </v-list-tile-content>
        </v-list-tile>
        <v-list-tile router :to="'/'">
        <v-list-tile-action>
          <v-icon color="light-green">contact_mail</v-icon>
        </v-list-tile-action>
        <v-list-tile-content>
          <v-list-tile-title color="light-green">Dashboard</v-list-tile-title>
        </v-list-tile-content>
        </v-list-tile>
      </v-list>
    </v-navigation-drawer>
    <v-toolbar class="primary" dark fixed app>
      <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
      <v-toolbar-title>BlockID - Legally Binding Blockchain Identity</v-toolbar-title>
    </v-toolbar>
    <v-content>
      <v-container fluid fill-height>
        <v-layout justify-center align-center>
          <router-view></router-view>
        </v-layout>
      </v-container>
    </v-content>
  </v-app>
</template>

<script>
export default {
  name: 'app'
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
