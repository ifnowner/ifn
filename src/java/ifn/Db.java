/*
 * Copyright © 2013-2016 The Nxt Core Developers.
 * Copyright © 2016 Jelurida IP B.V.
 *
 * See the LICENSE.txt file at the top-level directory of this distribution
 * for licensing information.
 *
 * Unless otherwise agreed in a custom licensing agreement with Jelurida B.V.,
 * no part of the Nxt software, including this file, may be copied, modified,
 * propagated, or distributed except according to the terms contained in the
 * LICENSE.txt file.
 *
 * Removal or modification of this copyright notice is prohibited.
 *
 */

package ifn;

import ifn.db.BasicDb;
import ifn.db.TransactionalDb;

public final class Db {

    public static final String PREFIX = Constants.isTestnet ? "ifn.testDb" : "ifn.db";
    public static final TransactionalDb db = new TransactionalDb(new BasicDb.DbProperties()
            .maxCacheSize(Ifn.getIntProperty("ifn.dbCacheKB"))
            .dbUrl(Ifn.getStringProperty(PREFIX + "Url"))
            .dbType(Ifn.getStringProperty(PREFIX + "Type"))
            .dbDir(Ifn.getStringProperty(PREFIX + "Dir"))
            .dbParams(Ifn.getStringProperty(PREFIX + "Params"))
            .dbUsername(Ifn.getStringProperty(PREFIX + "Username"))
            .dbPassword(Ifn.getStringProperty(PREFIX + "Password", null, true))
            .maxConnections(Ifn.getIntProperty("ifn.maxDbConnections"))
            .loginTimeout(Ifn.getIntProperty("ifn.dbLoginTimeout"))
            .defaultLockTimeout(Ifn.getIntProperty("ifn.dbDefaultLockTimeout") * 1000)
            .maxMemoryRows(Ifn.getIntProperty("ifn.dbMaxMemoryRows"))
    );

    static void init() {
        db.init(new IfnDbVersion());
    }

    static void shutdown() {
        db.shutdown();
    }

    private Db() {} // never

}
