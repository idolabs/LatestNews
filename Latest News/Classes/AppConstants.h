//
//  AppConstants.h
//  Latest News
//
//  Created by Inanc Sevinc on 9/1/12.
//  Copyright (c) 2012 idolabs. All rights reserved.
//

#ifndef Latest_News_AppConstants_h
#define Latest_News_AppConstants_h

#define ROTATION_DEGREE_90_CW                   (M_PI * 0.5)
#define ROTATION_DEGREE_90_CCW                  (M_PI * -0.5)


#define IS_IPAD                                 UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define MAIN_TABLE_CELL__NEWS_ITEM_CELL_WIDTH   (IS_IPAD ? 160:100)
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define MAIN_TABLE_CELL__NEWS_ITEM_CELL_HEIGHT  (IS_IPAD ? 160:100)

#define MAIN_TABLE_VIEW__HEADER_SECTION_HEIGHT  (IS_IPAD ? 32:20)
//#define MAIN_TABLE_VIEW_BACKGROUND_COLOR        [UIColor scrollViewTexturedBackgroundColor]


#define SHARED_CONTEXT_KEY_ALL_NEWS_DATA                                    @"ALL_NEWS_DATA"
#define SHARED_CONTEXT_KEY__SORTED_RSS_SOURCES_KEYS                         @"SORTED_RSS_SOURCES_KEYS"
#define SHARED_CONTEXT_KEY_SELECTED_NEWS_ITEM                               @"SELECTED_NEWS_ITEM"
#define SHARED_CONTEXT_KEY__VIEW_CONTROLLERS_PREFIX                         @"VIEW_CONTROLLERS_PREFIX__"


#define STORYBOARD_KEY__SEGUE__NEWS_ITEM_WEB_VIEW   @"SEGUE__NEWS_ITEM_WEB_VIEW"
#define STORYBOARD_KEY__ID__MAIN_TABLE_CELL         @"ID__MAIN_TABLE_CELL"
#define STORYBOARD_KEY__ID__NEWS_ITEM_TABLE_CELL    @"ID__NEWS_ITEM_TABLE_CELL"

#define NEWS_ITEM_CELL_IMAGE_PADDING            5
#define NEWS_ITEM_CELL_IMAGE_BORDER_WIDTH       0.5f
#define NEWS_ITEM_CELL_LABEL_VIEW_HEIGHT_RATIO  0.30
#define NEWS_ITEM_CELL_ROTATION                 ROTATION_DEGREE_90_CW
#define NEWS_ITEM_CELL_LABEL_NUMBER_OF_LINES    2
#define NEWS_ITEM_CELL_LABEL_FONT               [UIFont boldSystemFontOfSize:11]
#define NEWS_ITEM_CELL_LABEL_BACKGROUND_COLOR   [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define NEWS_ITEM_CELL_LABEL_COLOR              [UIColor whiteColor];

// Background color for the horizontal table view (the one embedded inside the rows of our vertical table)
#define MAIN_TABLE_CELL__NEWS_ITEMS_TABLE_BACKGROUND_COLOR     [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.2]
#define MAIN_TABLE_CELL__NEWS_ITEMS_TABLE_ROTATION  ROTATION_DEGREE_90_CCW

#define RSS_SOURCES_PLIST_URL                       @"https://s3-eu-west-1.amazonaws.com/idolabs/rss_sources.plist"
#define RSS_SOURCES_REQUEST_TIMEOUT_IN_SECONDS      1
#define RSS_SOURCES_DEFAULT_RESPONSE_HEADER_EXPIRES 60

#define USERDEFAULTS_KEY__RSS_SOURCES               @"RSS_SOURCES"
#define USERDEFAULTS_KEY__RSS_SOURCES_EXPIRE_DATE   @"RSS_SOURCES_EXPIRE_DATE"

#endif