/*
 * The MIT License
 *
 * Copyright (c) 2019, CloudBees, Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.csanchez.jenkins.lambda;

import com.amazonaws.services.lambda.runtime.ClientContext;
import com.amazonaws.services.lambda.runtime.CognitoIdentity;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.LambdaLogger;

/**
 * @author Carlos Sanchez
 * @since
 *
 */
public class StubContext implements Context {

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getAwsRequestId()
     */
    public String getAwsRequestId() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getLogGroupName()
     */
    public String getLogGroupName() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getLogStreamName()
     */
    public String getLogStreamName() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getFunctionName()
     */
    public String getFunctionName() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getFunctionVersion()
     */
    public String getFunctionVersion() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getInvokedFunctionArn()
     */
    public String getInvokedFunctionArn() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getIdentity()
     */
    public CognitoIdentity getIdentity() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getClientContext()
     */
    public ClientContext getClientContext() {
        // TODO Auto-generated method stub
        return null;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getRemainingTimeInMillis()
     */
    public int getRemainingTimeInMillis() {
        // TODO Auto-generated method stub
        return 0;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getMemoryLimitInMB()
     */
    public int getMemoryLimitInMB() {
        // TODO Auto-generated method stub
        return 0;
    }

    /* (non-Javadoc)
     * @see com.amazonaws.services.lambda.runtime.Context#getLogger()
     */
    public LambdaLogger getLogger() {
        // TODO Auto-generated method stub
        return null;
    }

}
