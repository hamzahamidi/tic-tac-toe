import { App } from 'aws-cdk-lib';
import { EvidenceStack } from '../lib/evidence-stack';
import { StaticSiteStack } from '../lib/static-site-stack';

const app = new App();

const env = {
  account: process.env.CDK_DEFAULT_ACCOUNT,
  region: process.env.CDK_DEFAULT_REGION ?? 'eu-west-1',
};

for (const envName of ['staging', 'production'] as const) {
  new StaticSiteStack(app, `TicTacToe-${envName}`, {
    env,
    envName,
    domainName: app.node.tryGetContext(`${envName}:domainName`),
    certificateArn: app.node.tryGetContext(`${envName}:certificateArn`),
  });
}

new EvidenceStack(app, 'TicTacToe-evidence', { env });
