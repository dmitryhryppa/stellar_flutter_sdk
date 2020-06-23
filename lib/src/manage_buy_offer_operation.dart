// Copyright 2020 The Stellar Flutter SDK Authors. All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE file.

import 'operation.dart';
import 'assets.dart';
import 'util.dart';
import 'xdr/xdr_operation.dart';
import 'xdr/xdr_type.dart';
import 'xdr/xdr_offer.dart';
import 'price.dart';

/// Represents <a href="https://www.stellar.org/developers/learn/concepts/list-of-operations.html#manage-buy-offer" target="_blank">ManageBuyOffer</a> operation.
/// See: <a href="https://www.stellar.org/developers/learn/concepts/list-of-operations.html" target="_blank">List of Operations</a>
class ManageBuyOfferOperation extends Operation {
  Asset _selling;
  Asset _buying;
  String _amount;
  String _price;
  int _offerId;

  ManageBuyOfferOperation(
      Asset selling, Asset buying, String amount, String price, int offerId) {
    this._selling = checkNotNull(selling, "selling cannot be null");
    this._buying = checkNotNull(buying, "buying cannot be null");
    this._amount = checkNotNull(amount, "amount cannot be null");
    this._price = checkNotNull(price, "price cannot be null");
    this._offerId = offerId;
  }

  /// The asset being sold in this operation
  Asset get selling => _selling;

  /// The asset being bought in this operation
  Asset get buying => _buying;

  /// Amount of selling being sold.
  String get amount => _amount;

  /// Price of 1 unit of selling in terms of buying.
  String get price => _price;

  /// The ID of the offer.
  int get offerId => _offerId;

  @override
  XdrOperationBody toOperationBody() {
    XdrManageBuyOfferOp op = new XdrManageBuyOfferOp();
    op.selling = selling.toXdr();
    op.buying = buying.toXdr();
    XdrInt64 amount = new XdrInt64();
    amount.int64 = Operation.toXdrAmount(this.amount);
    op.amount = amount;
    Price price = Price.fromString(this.price);
    op.price = price.toXdr();
    XdrUint64 offerId = new XdrUint64();
    offerId.uint64 = this.offerId;
    op.offerID = offerId;

    XdrOperationBody body = new XdrOperationBody();
    body.discriminant = XdrOperationType.MANAGE_BUY_OFFER;
    body.manageBuyOfferOp = op;

    return body;
  }

  /// Construct a new CreateAccount builder from a CreateAccountOp XDR.
  static ManageBuyOfferOperationBuilder builder(XdrManageBuyOfferOp op) {
    int n = op.price.n.int32.toInt();
    int d = op.price.d.int32.toInt();

    return ManageBuyOfferOperationBuilder(
      Asset.fromXdr(op.selling),
      Asset.fromXdr(op.buying),
      Operation.fromXdrAmount(op.amount.int64.toInt()),
      removeTailZero((BigInt.from(n) / BigInt.from(d)).toString()),
    ).setOfferId(op.offerID.uint64.toInt());
  }
}

class ManageBuyOfferOperationBuilder {
  Asset _selling;
  Asset _buying;
  String _amount;
  String _price;
  int _offerId = 0;
  String _mSourceAccount;

  /// Creates a new ManageBuyOfferOperation builder. If you want to update existing offer use
  ManageBuyOfferOperationBuilder(
      Asset selling, Asset buying, String amount, String price) {
    this._selling = checkNotNull(selling, "selling cannot be null");
    this._buying = checkNotNull(buying, "buying cannot be null");
    this._amount = checkNotNull(amount, "amount cannot be null");
    this._price = checkNotNull(price, "price cannot be null");
  }

  /// Sets offer ID. <code>0</code> creates a new offer. Set to existing offer ID to change it.
  ManageBuyOfferOperationBuilder setOfferId(int offerId) {
    this._offerId = offerId;
    return this;
  }

  ///Sets the source account for this operation.
  ManageBuyOfferOperationBuilder setSourceAccount(String sourceAccount) {
    _mSourceAccount =
        checkNotNull(sourceAccount, "sourceAccount cannot be null");
    return this;
  }

  /// Builds a ManageBuyOfferOperation.
  ManageBuyOfferOperation build() {
    ManageBuyOfferOperation operation =
    new ManageBuyOfferOperation(_selling, _buying, _amount, _price, _offerId);
    if (_mSourceAccount != null) {
      operation.sourceAccount = _mSourceAccount;
    }
    return operation;
  }
}