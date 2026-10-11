import { Given, When, Then } from '@badeball/cypress-cucumber-preprocessor';

Given('I open the game', () => {
  cy.visit('/');
});

When('I play the cells {string}', (moves: string) => {
  moves.split(',').forEach((cell) => {
    cy.get(`[data-testid="cell-${cell.trim()}"]`).click();
  });
});

When('I start a new game', () => {
  cy.get('[data-testid="reset"]').click();
});

Then('the status reads {string}', (text: string) => {
  cy.get('[data-testid="status"]').should('have.text', text);
});

Then('cell {int} shows {string}', (cell: number, mark: string) => {
  cy.get(`[data-testid="cell-${cell}"]`).should('have.text', mark);
});

Then('the board is empty', () => {
  cy.get('.cell').each(($cell) => {
    cy.wrap($cell).should('have.text', '').and('not.be.disabled');
  });
});

Then('the board is locked', () => {
  cy.get('.cell').each(($cell) => {
    cy.wrap($cell).should('be.disabled');
  });
});

Then('the environment banner shows the target environment', () => {
  cy.get('[data-testid="env-banner"]').should('have.text', Cypress.expose('ENV_NAME'));
});

Then('the build version is shown', () => {
  cy.get('[data-testid="build-version"]')
    .invoke('text')
    .should('match', /^\S+-\S+$/)
    .and('not.contain', '__BUILD_VERSION__');
  cy.get('meta[name="build-version"]')
    .invoke('attr', 'content')
    .should('not.contain', '__BUILD_VERSION__');
});
