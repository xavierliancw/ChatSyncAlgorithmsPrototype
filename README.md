# Data Sync Algorithms Prototype
This is a practice run at a data synchronization subroutine. It started with a small .playground file, but the single page ballooned and got unmanageable. So I decided to create a project so I can separate all the UI from the algorithms.
I put this on GitHub because... why not?

## What's Up?
- The UI consists of 4 collection views in 4 columns
- The top button wipes them and generates new data
- The first column shows data that's current
- The second column shows data that is fresh and is coming in
- The third column shows that the data should look like after the fresh data has been incorporated into the first column (note that it's not a merge of 2 arrays, but a special incorporation)
- The fourth column looks like the first column and will be the one that gets updated to look like the third column
- Red cells represent data that's been created locally but not synced with the backend or whatever yet (so incoming data may or may not have received that data, so my algorithms have to figure out which ones get updated or not)
- Also, red cells appear at the bottom after each incorporation so they don't get lost as more data flows in

## Why?
- This particular synchronization/update model is specialized for another project I'm working on
- Data comes in at a fixed size
- Only the latest data comes in per call
- Data on the device is built from the little fixed sized packets of data that comes in over time
- This exercise is a prototype to get all this logic working
- It's practice to learn how batch updates work on UICollectionViews
- And then it's just plain algorithm design practice to get efficient logic
