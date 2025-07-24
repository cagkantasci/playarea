
<template>
  <nav style="margin-bottom: 2rem;">
    <router-link to="/">Ana Sayfa</router-link> |
    <router-link to="/users">Kullanıcılar</router-link> |
    <router-link to="/roles">Roller</router-link> |
    <router-link to="/machines">Makineler</router-link> |
    <router-link to="/categories">Kategoriler</router-link> |
    <router-link to="/checklist-templates">Checklist Şablonları</router-link> |
    <router-link to="/checklists">Checklistler</router-link> |
    <router-link to="/checklist-responses">Cevaplar</router-link> |
    <router-link to="/issues">Sorunlar</router-link> |
    <router-link to="/approvals">Onaylar</router-link>
  </nav>
  <router-view />
</template>


<style scoped>
nav {
  font-size: 1.2rem;
  margin-bottom: 2rem;
}
nav a {
  margin-right: 1rem;
  text-decoration: none;
  color: #42b983;
}
nav a.router-link-exact-active {
  font-weight: bold;
  color: #35495e;
}
</style>
