//
//  BDSettingsViewController.m
//  BDWebImage_Example
//
//

#import "BDSettingsViewController.h"
#import "BDImageSettingModel.h"
#import "BDImageAdapter.h"
#import <Masonry/Masonry.h>

static NSString * const CellReuseIdentifier = @"BDImageSettingsSelectCell";

@interface BDImageSettingsSelectCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *info;
@property (nonatomic, strong) UISwitch *select;

@end

@implementation BDImageSettingsSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).mas_offset(16);
        }];
        _select = [UISwitch new];
        _select.hidden = YES;
        _select.onTintColor = [UIColor systemBlueColor];
        [self.contentView addSubview:_select];
        [_select mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-16);
            make.centerY.equalTo(self.contentView);
        }];
        _info = [UITextField new];
        _info.font = [UIFont systemFontOfSize:16];
        _info.hidden = YES;
        _info.textColor = [UIColor grayColor];
        _info.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_info];
        [_info mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-16);
            make.left.equalTo(_label.mas_right).mas_offset(16);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
        }];
        [_info resignFirstResponder];
    }
    return self;
}

@end

@interface BDSettingsViewController ()<UITextFieldDelegate>

@end

@implementation BDSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[BDImageSettingsSelectCell class] forCellReuseIdentifier:CellReuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _settings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDImageSettingsSelectCell *cell = (BDImageSettingsSelectCell *)[tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    if (cell == nil) {
        cell = [[BDImageSettingsSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellReuseIdentifier];
    }
    BDImageSettingModel *model = _settings[indexPath.row];
    cell.label.text = model.name;
    if (model.info.length > 0) {
        cell.info.hidden = NO;
        cell.info.text = model.info;
        cell.info.delegate = self;
        cell.info.tag = indexPath.row;
    } else {
        cell.info.hidden = YES;
    }
    if (model.type == BDImageSettingSelectType) {
        cell.select.on = model.showSelect();
        cell.select.tag = indexPath.row;
        [cell.select addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.select.hidden = NO;
    } else {
        cell.select.hidden = YES;
    }
    return cell;
}

- (void)switchAction:(UISwitch *)sender {
    BDImageSettingModel *model = _settings[sender.tag];
    model.selectItem();
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BDImageSettingModel *model = _settings[indexPath.row];
    if (model.type == BDImageSettingActionType) {
        if ([model.name isEqualToString:@"清除缓存"]) {
            [[BDWebImageManager sharedManager].imageCache clearDiskWithBlock:^{
                [[BDWebImageManager sharedManager].imageCache clearMemory];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"缓存已清" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }]];
                    [self presentViewController:alert animated:YES completion:nil];
                    BDImageSettingsSelectCell *cell = (BDImageSettingsSelectCell *)[tableView cellForRowAtIndexPath:indexPath];
                    cell.info.text = @"0";
                });
                [[BDImageAdapter sharedAdapter] updateCacheSize];
            }];
        } else if ([model.name isEqualToString:@"缓存控制"]) {
            BDSettingsViewController *vc = [BDSettingsViewController new];
            vc.navigationItem.title = @"缓存配置";
            vc.settings = [BDImageSettingModel cacheSettingModels];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    BDImageSettingModel *model = _settings[textField.tag];
    return model.type == BDImageSettingEditType;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    BDImageSettingModel *model = _settings[textField.tag];
    NSString *text = textField.text;
    if (text.length > 0) {
        model.info = text;
        model.action();
    }
}

@end
