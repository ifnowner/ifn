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

package ifn.http;

import ifn.Account;
import ifn.Attachment;
import ifn.IfnException;
import ifn.Shuffling;
import org.json.simple.JSONStreamAware;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

public final class ShufflingVerify extends CreateTransaction {

    static final ShufflingVerify instance = new ShufflingVerify();

    private ShufflingVerify() {
        super(new APITag[] {APITag.SHUFFLING, APITag.CREATE_TRANSACTION}, "shuffling", "shufflingStateHash");
    }

    @Override
    protected JSONStreamAware processRequest(HttpServletRequest req) throws IfnException {
        Shuffling shuffling = ParameterParser.getShuffling(req);
        byte[] shufflingStateHash = ParameterParser.getBytes(req, "shufflingStateHash", true);
        if (!Arrays.equals(shufflingStateHash, shuffling.getStateHash())) {
            return JSONResponses.incorrect("shufflingStateHash", "Shuffling is in a different state now");
        }
        Attachment attachment = new Attachment.ShufflingVerification(shuffling.getId(), shufflingStateHash);

        Account account = ParameterParser.getSenderAccount(req);
        return createTransaction(req, account, attachment);
    }
}