//
//  LocationsViewController.m
//  PhotoMap
//
//  Created by emersonmalca on 7/8/18.
//  Copyright © 2018 Codepath. All rights reserved.
//

#import "LocationsViewController.h"
#import "LocationCell.h"
#import "AFNetworking.h"

static NSString * const clientID = @"QA1L0Z0ZNA2QVEEDHFPQWK0I5F1DE3GPLSNW4BZEBGJXUCFL";
static NSString * const clientSecret = @"W2AOE1TYC4MHK5SZYOUGX0J3LVRALMPB4CXT3ZH21ZCPUMCU";

@interface LocationsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *results;

@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    [cell updateWithLocation:self.results[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    NSNumber *lat = [venue valueForKeyPath:@"location.lat"];
    NSNumber *lng = [venue valueForKeyPath:@"location.lng"];
    NSLog(@"%@, %@", lat, lng);
    
    [self.delegate locationsViewController:self didPickLocationWithLatitude:lat longitude:lng];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText nearCity:@"San Francisco"];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text nearCity:@"San Francisco"];
}


- (void)fetchLocationsWithQuery:(NSString *)query nearCity:(NSString *)city {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@", clientID, clientSecret, city, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       if (data) {
           // Hardcode in locations
           NSString *jsonString = @"{ \"meta\": { \"code\": 200, \"requestId\": \"5ac51d7e6a607143d811cecb\" }, \"response\": { \"venues\": [ { \"id\": \"5642aef9498e51025cf4a7a5\", \"name\": \"Mr. Purple\", \"location\": { \"address\": \"180 Orchard St\", \"crossStreet\": \"btwn Houston & Stanton St\", \"lat\": 40.72173744277209, \"lng\": -73.98800687282996, \"labeledLatLngs\": [ { \"label\": \"display\", \"lat\": 40.72173744277209, \"lng\": -73.98800687282996 } ], \"distance\": 8, \"postalCode\": \"10002\", \"cc\": \"US\", \"city\": \"New York\", \"state\": \"NY\", \"country\": \"United States\", \"formattedAddress\": [ \"180 Orchard St (btwn Houston & Stanton St)\", \"New York, NY 10002\", \"United States\" ] }, \"categories\": [ { \"id\": \"4bf58dd8d48988d1d5941735\", \"name\": \"Hotel Bar\", \"pluralName\": \"Hotel Bars\", \"shortName\": \"Hotel Bar\", \"icon\": { \"prefix\": \"https:\/\/ss3.4sqi.net\/img\/categories_v2\/travel\/hotel_bar_\", \"suffix\": \".png\" }, \"primary\": true } ], \"venuePage\": { \"id\": \"150747252\" } } ] } }";
           NSError *jsonError;
           NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
           NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:objectData
                                                                              options:NSJSONReadingMutableContainers
                                                                                error:&jsonError];
           self.results = [responseDictionary valueForKeyPath:@"response.venues"];
           
           
           //NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
           NSLog(@"response: %@", responseDictionary);
           self.results = [responseDictionary valueForKeyPath:@"response.venues"];
           [self.tableView reloadData];
        }
    }];
    [task resume];
}

@end
