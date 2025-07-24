import { createRouter, createWebHistory } from 'vue-router';

import LoginView from '../views/LoginView.vue';
import DashboardView from '../views/DashboardView.vue';
import MachinesView from '../views/MachinesView.vue';
import CategoriesView from '../views/CategoriesView.vue';
import UsersView from '../views/UsersView.vue';



import RolesView from '../views/RolesView.vue';
import ChecklistTemplatesView from '../views/ChecklistTemplatesView.vue';

import ChecklistItemsView from '../views/ChecklistItemsView.vue';

import IssuesView from '../views/IssuesView.vue';
import ApprovalsView from '../views/ApprovalsView.vue';

const routes = [
  { path: '/', name: 'dashboard', component: DashboardView },
  { path: '/login', name: 'login', component: LoginView },
  { path: '/machines', name: 'machines', component: MachinesView },
  { path: '/categories', name: 'categories', component: CategoriesView },
  { path: '/users', name: 'users', component: UsersView },
  { path: '/roles', name: 'roles', component: RolesView },
  { path: '/checklist-templates', name: 'checklist-templates', component: ChecklistTemplatesView },
  { path: '/checklist-items', name: 'checklist-items', component: ChecklistItemsView },
  { path: '/issues', name: 'issues', component: IssuesView },
  { path: '/approvals', name: 'approvals', component: ApprovalsView },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

import { useAuthStore } from '../stores/auth';

router.beforeEach((to, from, next) => {
  const auth = useAuthStore();
  const publicPages = ['/login'];
  const authRequired = !publicPages.includes(to.path);
  if (authRequired && !auth.token) {
    return next('/login');
  }
  if (to.path === '/login' && auth.token) {
    return next('/');
  }
  next();
});

export default router;