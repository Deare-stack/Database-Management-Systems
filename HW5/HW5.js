/*Title: DB Assignment 5
Your Name: Deare
Date: 2024/11/15
/*
/*
Query 1:Over how many years was the unemployment data collected?
*/  

db.unemployment.aggregate([
  {
    $group:
      /**
       * _id: The id of the group.
       * fieldN: The first field name.
       */
      {
        _id: "$Year"
      }
  },
  {
    $count:
      /**
       * Provide the field name for the count.
       */
      "YearSpan"
  }
])

/*
Query 2:How many states were reported on in this dataset?
*/
db.unemployment.aggregate([
  {
    $group:
      /**
       * _id: The id of the group.
       * fieldN: The first field name.
       */
      {
        _id: "$State"
      }
  },
  {
    $count:
      /**
       * Provide the field name for the count.
       */
      "NumberOfState"
  }
])
/*
Query 3:What does this query compute?
db.unemployment.find({Rate : {$lt: 1.0}}).count()
*/
//This query means that retrieved unemployed people who have a Rate less than 1.0 and then counted their number.

/*
Query 4:Find all counties with unemployment rate higher than 10%
*/
db.getCollection('unemployment').aggregate(
  [
    {
      $project: {
        _id: 0,
        State: 1,
        County: 1,
        Rate: 1
      }
    },
    { $match: { Rate: { $gt: 10 } } }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);
/*
Query 5:Calculate the average unemployment rate across all states.
*/

db.getCollection('unemployment').aggregate(
  [
    { $project: { _id: 0, State: 1, Rate: 1 } },
    {
      $group: {
        _id: '$State',
        averageRATE: { $avg: '$Rate' }
      }
    }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);

/*
Query 6:Find all states with an unemployment rate between 5% and 8%
*/
db.getCollection('unemployment').aggregate(
  [
    { $match: { Rate: { $gte: 5, $lte: 8 } } },
    {
      $project: {
        _id: 0,
        State: 1,
        County: 1,
        Rate: 1
      }
    }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);

/*
Query 7:Find the state with the highest unemployment rate. Hint. Use { $limit: 1 }
*/
db.getCollection('unemployment').aggregate(
  [
    { $sort: { Rate: -1 } },
    { $limit: 1 },
    { $project: { _id: 0, State: 1, Rate: 1 } }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);


/*
Query 8: Count how many counties have an unemployment rate above 5%.
*/
db.getCollection('unemployment').aggregate(
  [
    { $match: { Rate: { $gt: 5 } } },
    { $group: { _id: '$County' } },
    { $count: 'NumberOfCounties' }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);

/*
Query 9:Calculate the average unemployment rate per state by year.
*/
db.getCollection('unemployment').aggregate(
  [
    {
      $group: {
        _id: { State: '$State', Year: '$Year' },
        countAverageRate: { $avg: '$Rate' }
      }
    },
    {
      $project: {
        _id: 0,
        State: '$_id.State', // Map ‘State’ from the group '_id'
        Year: '$_id.Year', // Map 'Year' from the group '_id'
        countAverageRate: 1
      }
    },
    { $sort: { State: 1, Year: 1 } }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);

/*
Query 10:(Extra Credit) For each state, calculate the total unemployment rate across all counties (sum of all county rates).
*/
db.getCollection('unemployment').aggregate(
  [
    {
      $group: {
        _id: '$County',
        TOTALsumRate: { $sum: '$Rate' }
      }
    },
    {
      $project: {
        _id: 0,
        County: '$_id',
        TOTALsumRate: 1
      }
    },
    { $sort: { State: 1 } }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);

/*
Query 11:(Extra Credit) The same as Query 10 but for states with data from 2015 onward
*/
db.getCollection('unemployment').aggregate(
  [
    { $match: { Year: { $gt: 2015 } } },
    {
      $group: {
        _id: '$State',
        TOTALsumRateAFTER2015: { $sum: '$Rate' }
      }
    },
    {
      $project: {
        _id: 0,
        State: '$_id',
        TOTALsumRateAFTER2015: 1
      }
    },
    { $sort: { State: 1 } }
  ],
  { maxTimeMS: 60000, allowDiskUse: true }
);
