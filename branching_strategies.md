## Branching Strategies

main branch 
    |
release branch
    |
feature branches

## Trunk based strategy
-> One single branch always ready to deploy
-> People are always working on feature branches which are merged into the main branch
-> Sometimes, unfinished code is pushed....that's where feature flags are used.
-> creates some problems:
    -> hard to manage
    -> the transactions(push, pull, merge etc.) are very short lived(less than a day).
    -> there's no proper testing => solution is proper automated testing(need a good testing strategy)
    -> 
## GitLab flow
-> Create different branched for different environments(ex: development, staging, production)
-> Each environment will have different criterias.
-> Whenever a merge happens between env, pipeline is triggered and a specific operation occurs.
-> Shift left strategy can be used to catch errors and bugs earlier, in earlier env.
-> Complex and more time consuming as compared to Trunk based.
-> 