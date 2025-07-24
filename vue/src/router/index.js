import { createRouter, createWebHistory } from 'vue-router';


const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/HomeView.vue'),
  },
  {
    path: '/users',
    name: 'Users',
    component: () => import('../views/UsersView.vue'),
  },
  {
    path: '/roles',
    name: 'Roles',
    component: () => import('../views/RolesView.vue'),
  },
  {
    path: '/machines',
    name: 'Machines',
    component: () => import('../views/MachinesView.vue'),
  },
  {
    path: '/categories',
    name: 'Categories',
    component: () => import('../views/CategoriesView.vue'),
  },
  {
    path: '/checklist-templates',
    name: 'ChecklistTemplates',
    component: () => import('../views/ChecklistTemplatesView.vue'),
  },
  {
    path: '/checklists',
    name: 'Checklists',
    component: () => import('../views/ChecklistsView.vue'),
  },
  {
    path: '/checklist-responses',
    name: 'ChecklistResponses',
    component: () => import('../views/ChecklistResponsesView.vue'),
  },
  {
    path: '/issues',
    name: 'Issues',
    component: () => import('../views/IssuesView.vue'),
  },
  {
    path: '/approvals',
    name: 'Approvals',
    component: () => import('../views/ApprovalsView.vue'),
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
